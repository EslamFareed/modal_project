import 'package:cloud_firestore/cloud_firestore.dart';

class BuildingModel {
  String? id;
  String? name;
  num? lat;
  num? long;

  BuildingModel({this.id, this.lat, this.name, this.long});

  BuildingModel.fromFirebase(QueryDocumentSnapshot<Map<String, dynamic>> e) {
    id = e.id;
    name = e.data()["name"];
    lat = e.data()["lat"];
    long = e.data()["long"];
  }
}
