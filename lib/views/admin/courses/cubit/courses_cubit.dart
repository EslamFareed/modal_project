import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:meta/meta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/course_model.dart';
part 'courses_state.dart';

class CoursesCubit extends Cubit<CoursesState> {
  CoursesCubit() : super(CoursesInitial());

  static CoursesCubit get(context) => BlocProvider.of(context);

  final firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  List<CourseModel> courses = [];

  void getCourses() async {
    emit(LoadingCoursesState());

    try {
      var data = await firestore.collection("courses").get();

      courses = data.docs.map((e) => CourseModel.fromFirebase(e)).toList();
      emit(SuccessCoursesState());
    } catch (e) {
      emit(ErrorCoursesState());
    }
  }

  void createCourse(String name, String code) async {
    emit(LoadingCoursesState());
    try {
      await firestore.collection("courses").add({"name": name, "code": code});

      emit(SuccessCoursesState());
    } catch (e) {
      emit(ErrorCoursesState());
    }
  }
}
