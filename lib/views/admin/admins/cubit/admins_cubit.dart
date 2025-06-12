import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:meta/meta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_project/views/admin/admins/models/admin_model.dart';
part 'admins_state.dart';

class AdminsCubit extends Cubit<AdminsState> {
  AdminsCubit() : super(AdminsInitial());

  static AdminsCubit get(context) => BlocProvider.of(context);

  final firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  List<AdminModel> admins = [];

  void getAdmins() async {
    emit(LoadingAdminsState());

    try {
      var data = await firestore.collection("admins").get();

      admins = data.docs.map((e) => AdminModel.fromFirebase(e)).toList();
      emit(SuccessAdminsState());
    } catch (e) {
      emit(ErrorAdminsState());
    }
  }

  void createAdmin(String email, String password) async {
    emit(LoadingAdminsState());
    try {
      var data = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (data.user != null) {
        await firestore.collection("admins").doc(data.user!.uid).set({
          "email": email,
          "password": password,
        });

        emit(SuccessAdminsState());
      } else {
        emit(ErrorAdminsState());
      }
    } catch (e) {
      emit(ErrorAdminsState());
    }
  }
}
