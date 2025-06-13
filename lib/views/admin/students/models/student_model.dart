import 'package:cloud_firestore/cloud_firestore.dart';

import '../../courses/models/course_model.dart';

class StudentModel {
  String? id;
  String? idNumber;
  String? name;
  String? email;
  String? phone;
  String? password;
  Map<String, CourseModel>? courses;

  StudentModel({
    this.id,
    this.idNumber,
    this.name,
    this.email,
    this.phone,
    this.password,
    this.courses,
  });

  StudentModel.fromFirebase(QueryDocumentSnapshot<Map<String, dynamic>> e) {
    id = e.id;
    idNumber = e.data()["id"];
    name = e.data()["name"];
    email = e.data()["email"];
    phone = e.data()["phone"];
    password = e.data()["password"];

    if (e.data()["courses"] != null) {
      courses = {};
      Map<String, dynamic> coursesMap = e.data()["courses"];
      coursesMap.forEach((key, value) {
        courses![key] = CourseModel.fromMap(key, value);
      });
    }
  }

  StudentModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> e) {
    id = e.id;
    idNumber = e.data()!["id"];
    name = e.data()!["name"];
    email = e.data()!["email"];
    phone = e.data()!["phone"];
    password = e.data()!["password"];

    if (e.data()!["courses"] != null) {
      courses = {};
      Map<String, dynamic> coursesMap = e.data()!["courses"];
      coursesMap.forEach((key, value) {
        courses![key] = CourseModel.fromMap(key, value);
      });
    }
  }

  Map<String, dynamic> toMap() {
    return {
      "id": idNumber,
      "name": name,
      "email": email,
      "phone": phone,
      "password": password,
      "courses":
          courses != null
              ? courses!.map((key, course) => MapEntry(key, course.toMap()))
              : {},
    };
  }
}
