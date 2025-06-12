import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:meta/meta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_project/views/admin/courses/models/course_model.dart';
import 'package:modal_project/views/admin/students/models/student_model.dart';

part 'instructors_state.dart';

class InstructorsCubit extends Cubit<InstructorsState> {
  InstructorsCubit() : super(InstructorsInitial());

  static InstructorsCubit get(context) => BlocProvider.of(context);

  final firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  List<StudentModel> instructors = [];

  void getInstructors() async {
    emit(LoadingInstructorsState());

    try {
      var data = await firestore.collection("instructors").get();

      instructors = data.docs.map((e) => StudentModel.fromFirebase(e)).toList();

      emit(SuccessInstructorsState());
    } catch (e) {
      emit(ErrorInstructorsState());
    }
  }

  List<CourseModel> courses = [];
  void getCourses() async {
    emit(LoadingInstructorsState());
    try {
      var data = await firestore.collection("courses").get();
      courses = data.docs.map((e) => CourseModel.fromFirebase(e)).toList();
      emit(SuccessInstructorsCoursesState());
    } catch (e) {
      emit(ErrorInstructorsState());
    }
  }

  void createInstructor({
    required String name,
    required String id,
    required String phone,
    required String email,
    required String pass,
    required List<int> coursesIds,
  }) async {
    emit(LoadingInstructorsState());
    try {
      var authData = await auth.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );
      if (authData.user != null) {
        Map<String, CourseModel> coursesMap = {
          for (var course in coursesIds.map((e) => courses[e]))
            course.id!: course,
        };
        await firestore
            .collection("instructors")
            .doc(authData.user?.uid)
            .set(
              StudentModel(
                id: authData.user?.uid,
                idNumber: id,
                name: name,
                phone: phone,
                email: email,
                password: pass,
                courses: coursesMap,
              ).toMap(),
            );

        emit(SuccessInstructorsState());
      } else {
        emit(ErrorInstructorsState());
      }
    } catch (e) {
      emit(ErrorInstructorsState());
    }
  }
}
