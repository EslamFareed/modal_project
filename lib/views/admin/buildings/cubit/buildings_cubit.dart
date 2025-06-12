import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:meta/meta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/building_model.dart';
part 'buildings_state.dart';

class BuildingsCubit extends Cubit<BuildingsState> {
  BuildingsCubit() : super(BuildingsInitial());

  static BuildingsCubit get(context) => BlocProvider.of(context);

  final firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  List<BuildingModel> buildings = [];

  void getBuildings() async {
    emit(LoadingBuildingsState());

    try {
      var data = await firestore.collection("buildings").get();

      buildings = data.docs.map((e) => BuildingModel.fromFirebase(e)).toList();
      emit(SuccessBuildingsState());
    } catch (e) {
      emit(ErrorBuildingsState());
    }
  }

  double? lat;
  double? long;

  void createBuilding(String name) async {
    emit(LoadingBuildingsState());
    try {
      await firestore.collection("buildings").add({
        "name": name,
        "lat": lat,
        "long": long,
      });

      emit(SuccessBuildingsState());
    } catch (e) {
      emit(ErrorBuildingsState());
    }
  }
}
