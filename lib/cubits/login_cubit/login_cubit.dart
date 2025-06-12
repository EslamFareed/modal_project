import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:meta/meta.dart';

import '../../core/cache_helper.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  static LoginCubit get(context) => BlocProvider.of(context);

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void login({required String email, required String password}) async {
    emit(LoginLoadingState());
    try {
      var dataAuth = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (dataAuth.user != null) {
        var dataStudent =
            await firestore
                .collection("students")
                .doc(dataAuth.user?.uid)
                .get();
        if (dataStudent.data() != null) {
          CacheHelper.login(
            phone: dataStudent.data()!["phone"],
            name: dataStudent.data()!["name"],
            email: dataStudent.data()!["email"],
            id: dataAuth.user!.uid,
            idNumber: dataStudent.data()!["id"],
            type: 3,
          );
          emit(LoginStudentSuccessState());
        } else {
          var dataInstructor =
              await firestore
                  .collection("instructors")
                  .doc(dataAuth.user?.uid)
                  .get();
          if (dataInstructor.data() != null) {
            CacheHelper.login(
              phone: dataInstructor.data()!["phone"],
              name: dataInstructor.data()!["name"],
              email: dataInstructor.data()!["email"],
              id: dataAuth.user!.uid,
              idNumber: dataInstructor.data()!["id"],
              type: 2,
            );
            emit(LoginInstructorSuccessState());
          } else {
            var dataAdmin =
                await firestore
                    .collection("admins")
                    .doc(dataAuth.user?.uid)
                    .get();
            if (dataAdmin.data() != null) {
              CacheHelper.login(
                email: dataAdmin.data()!["email"],
                id: dataAuth.user!.uid,
                type: 1,
              );
              emit(LoginAdminSuccessState());
            } else {
              emit(LoginErrorState());
              return;
            }
          }
        }
      } else {
        emit(LoginErrorState());
        return;
      }
    } catch (e) {
      emit(LoginErrorState());
    }
  }
}
