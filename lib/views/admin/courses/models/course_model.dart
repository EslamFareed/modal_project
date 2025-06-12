import 'package:cloud_firestore/cloud_firestore.dart';

class CourseModel {
  String? id;
  String? name;
  String? code;

  CourseModel({this.id, this.code, this.name});

  CourseModel.fromFirebase(QueryDocumentSnapshot<Map<String, dynamic>> e) {
    id = e.id;
    name = e.data()["name"];
    code = e.data()["code"];
  }
}
