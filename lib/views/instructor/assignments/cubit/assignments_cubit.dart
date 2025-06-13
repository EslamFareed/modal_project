import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:meta/meta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_project/core/cache_helper.dart';

import '../../../admin/courses/models/course_model.dart';
import '../models/assignment_model.dart';
part 'assignments_state.dart';

class AssignmentsCubit extends Cubit<AssignmentsState> {
  AssignmentsCubit() : super(AssignmentsInitial());

  static AssignmentsCubit get(context) => BlocProvider.of(context);

  final firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  List<AssignmentModel> assignments = [];

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
}
