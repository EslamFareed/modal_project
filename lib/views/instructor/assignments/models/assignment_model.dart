import 'package:cloud_firestore/cloud_firestore.dart';

class AssignmentModel {
  String? file;
  String? instructor;
  String? text;
  Timestamp? deadline;
  Map<String, StudentAnswer>? answers;
  Map<String, CourseAssignmentModel>? course;
  String? id;

  AssignmentModel({
    this.file,
    this.instructor,
    this.text,
    this.deadline,
    this.answers,
    this.course,
    this.id,
  });

  AssignmentModel.fromFirebase(QueryDocumentSnapshot<Map<String, dynamic>> e) {
    final data = e.data();
    id = e.id;
    file = data['file'];
    instructor = data['instructor'];
    text = data['text'];
    deadline = data['deadline'];

    if (data['answers'] != null) {
      answers = {};
      (data['answers'] as Map<String, dynamic>).forEach((key, value) {
        answers![key] = StudentAnswer.fromMap(value);
      });
    }

    if (data['course'] != null) {
      course = {};
      (data['course'] as Map<String, dynamic>).forEach((key, value) {
        course![key] = CourseAssignmentModel.fromMap(key, value);
      });
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'file': file,
      'instructor': instructor,
      'text': text,
      'deadline': deadline,
      'answers': answers?.map((key, value) => MapEntry(key, value.toMap())),
      'course': course?.map((key, value) => MapEntry(key, value.toMap())),
    };
  }
}

class StudentAnswer {
  String? id;
  String? name;
  String? email;
  String? phone;
  String? answer;

  StudentAnswer({this.id, this.name, this.email, this.phone, this.answer});

  StudentAnswer.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    name = data['name'];
    email = data['email'];
    phone = data['phone'];
    answer = data['answer'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      "answer": answer,
    };
  }
}

class CourseAssignmentModel {
  String? id;
  String? name;
  String? code;

  CourseAssignmentModel({this.id, this.code, this.name});

  CourseAssignmentModel.fromMap(String id, Map<String, dynamic> data) {
    this.id = id;
    name = data["name"];
    code = data["code"];
  }

  Map<String, dynamic> toMap() {
    return {"name": name, "code": code};
  }
}
