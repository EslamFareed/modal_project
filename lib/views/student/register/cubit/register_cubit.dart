import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../admin/courses/models/course_model.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  static RegisterCubit get(context) => BlocProvider.of(context);

  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  Future<void> registerStudent({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String idNumber,
    required List<CourseModel> selectedCourses,
  }) async {
    emit(RegisterLoading());

    try {
      final userCred = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      Map<String, Map<String, dynamic>> coursesMap = {
        for (var course in selectedCourses) course.id!: course.toMap(),
      };
      await firestore.collection('students').doc(userCred.user!.uid).set({
        'email': email,
        'name': name,
        'phone': phone,
        'id': idNumber,
        'password': password,
        'courses': coursesMap,
      });

      emit(RegisterSuccess());
    } catch (e) {
      emit(RegisterError(e.toString()));
    }
  }

  List<CourseModel> courses = [];
  void getCourses() async {
    emit(RegisterLoading());
    try {
      var data = await firestore.collection("courses").get();
      courses = data.docs.map((e) => CourseModel.fromFirebase(e)).toList();
      emit(SuccessRegisterCoursesState());
    } catch (e) {
      emit(RegisterError(e.toString()));
    }
  }
}
