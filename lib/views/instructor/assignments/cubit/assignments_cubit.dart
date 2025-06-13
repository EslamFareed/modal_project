import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:meta/meta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_project/core/cache_helper.dart';
import 'package:modal_project/views/admin/students/models/student_model.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../../admin/courses/models/course_model.dart';
import '../models/assignment_model.dart';
part 'assignments_state.dart';

class AssignmentsCubit extends Cubit<AssignmentsState> {
  AssignmentsCubit() : super(AssignmentsInitial());

  static AssignmentsCubit get(context) => BlocProvider.of(context);

  final firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  List<AssignmentModel> assignments = [];
  List<AssignmentModel> allAssignments = [];

  void getAssignments() async {
    emit(LoadingAssignmentsState());

    try {
      var data =
          await firestore
              .collection("assigments")
              .where("instructor", isEqualTo: CacheHelper.getId())
              .get();

      assignments =
          data.docs.map((e) => AssignmentModel.fromFirebase(e)).toList();

      emit(SuccessAssignmentsState());
    } catch (e) {
      emit(ErrorAssignmentsState());
    }
  }

  void getStudentAssignments(BuildContext context) async {
    emit(LoadingAssignmentsState());
    assignments.clear();
    try {
      var data = await firestore.collection("assigments").get();

      var studentDataDoc =
          await firestore.collection("students").doc(CacheHelper.getId()).get();

      var student = StudentModel.fromDoc(studentDataDoc);

      allAssignments =
          data.docs.map((e) => AssignmentModel.fromFirebase(e)).toList();
      for (var element in allAssignments) {
        if (student.courses!.containsKey(element.course!.keys.toList()[0])) {
          AssignmentModel current = element;
          current.isAnswered =
              current.answers?.containsKey(CacheHelper.getId()) ?? false;

          assignments.add(current);
        }
      }
      emit(SuccessAssignmentsState());
      scheduleReminders(assignments, context);
    } catch (e) {
      emit(ErrorAssignmentsState());
    }
  }

  Future<void> scheduleReminders(
    List<AssignmentModel> list,
    BuildContext context,
  ) async {
    final plugin = FlutterLocalNotificationsPlugin();

    final now = DateTime.now();

    for (final assignment in list) {
      final deadline = assignment.deadline?.toDate();
      if (deadline == null) continue;

      final diff = deadline.difference(now);

      // Only show reminders for assignments due in the next 24 hours and not answered
      if (diff.inHours <= 24 && !assignment.isAnswered) {
        await plugin.show(
          deadline.hashCode, // unique ID
          "⏰ Assignment Reminder: ${assignment.text}",
          "Your assignment is due at ${deadline.hour.toString().padLeft(2, '0')}:${deadline.minute.toString().padLeft(2, '0')}",
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'assignment_reminders',
              'Assignment Reminders',
              importance: Importance.max,
              priority: Priority.high,
            ),
          ),
        );
      }
    }

    final upcoming = list.where(
      (a) =>
          a.deadline != null &&
          a.deadline!.toDate().difference(DateTime.now()).inHours <= 24 &&
          !a.isAnswered,
    );

    if (upcoming.isNotEmpty) {
      Future.delayed(Duration.zero, () {
        showAssignmentReminderDialog(context, upcoming.first);
      });
    }
  }

  void showAssignmentReminderDialog(
    BuildContext context,
    AssignmentModel assignment,
  ) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text("⏰ Assignment Reminder"),
            content: Text(
              "Don't forget! \"${assignment.text}\" is due soon at "
              "${assignment.deadline!.toDate().hour.toString().padLeft(2, '0')}:"
              "${assignment.deadline!.toDate().minute.toString().padLeft(2, '0')}",
            ),
            actions: [
              TextButton(
                child: const Text("Dismiss"),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
    );
  }

  FirebaseStorage storage = FirebaseStorage.instance;

  void createAssignment({
    // required String instructorId,
    required String text,
    required PlatformFile file,
    required DateTime deadline,
    required int courseIndex,
  }) async {
    emit(LoadingAssignmentsState());

    try {
      File fileU = File(file.path ?? "");

      final storageRef = storage.ref();
      final imagesRef = storageRef.child("files/${file.name}");
      await imagesRef.putFile(fileU);
      String downloadURL = await imagesRef.getDownloadURL();

      final data = AssignmentModel(
        instructor: CacheHelper.getId(),
        text: text,
        file: downloadURL,
        deadline: Timestamp.fromDate(deadline),
        course: {
          "${courses[courseIndex].id}": CourseAssignmentModel(
            name: courses[courseIndex].name,
            code: courses[courseIndex].code,
          ),
        },
      );

      await firestore.collection("assigments").add(data.toMap());

      getAssignments(); // Refresh list
    } catch (e) {
      emit(ErrorAssignmentsState());
    }
  }

  List<CourseModel> courses = [];
  void getCourses() async {
    emit(LoadingAssignmentsState());
    try {
      var data = await firestore.collection("courses").get();
      courses = data.docs.map((e) => CourseModel.fromFirebase(e)).toList();
      emit(SuccessAssignmentCoursesState());
    } catch (e) {
      emit(ErrorAssignmentsState());
    }
  }

  void sendAnswer({
    required PlatformFile file,
    required AssignmentModel task,
    required BuildContext context
  }) async {
    try {
      emit(LoadingSendAnswerState());
      File fileU = File(file.path ?? "");

      final storageRef = storage.ref();
      final imagesRef = storageRef.child("files/${file.name}");
      await imagesRef.putFile(fileU);
      String downloadURL = await imagesRef.getDownloadURL();

      task.answers?.addAll({
        CacheHelper.getId(): StudentAnswer(
          answer: downloadURL,
          email: CacheHelper.getEmail(),
          id: CacheHelper.getIdNumber(),
          name: CacheHelper.getName(),
          phone: CacheHelper.getPhone(),
        ),
      });

      await firestore
          .collection("assigments")
          .doc(task.id)
          .update(task.toMap());

      emit(SuccessSendAnswerState());

      getStudentAssignments(context);
    } catch (e) {
      emit(ErrorSendAnswerState());
    }
  }
}
