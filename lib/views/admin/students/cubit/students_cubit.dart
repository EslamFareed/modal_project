import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:meta/meta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/student_model.dart';
part 'students_state.dart';

class StudentsCubit extends Cubit<StudentsState> {
  StudentsCubit() : super(StudentsInitial());

  static StudentsCubit get(context) => BlocProvider.of(context);

  final firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  List<StudentModel> students = [];

  void getStudents() async {
    emit(LoadingStudentsState());

    try {
      var data = await firestore.collection("students").get();

      students = data.docs.map((e) => StudentModel.fromFirebase(e)).toList();

      emit(SuccessStudentsState());
    } catch (e) {
      emit(ErrorStudentsState());
    }
  }
}
