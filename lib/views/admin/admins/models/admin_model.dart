import 'package:cloud_firestore/cloud_firestore.dart';

class AdminModel {
  String? id;
  String? email;
  String? password;

  AdminModel({this.email, this.id, this.password});

  AdminModel.fromFirebase(QueryDocumentSnapshot<Map<String, dynamic>> e) {
    id = e.id;
    email = e.data()["email"];
    password = e.data()["password"];
  }
}
