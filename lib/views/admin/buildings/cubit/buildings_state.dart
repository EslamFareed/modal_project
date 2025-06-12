part of 'buildings_cubit.dart';

@immutable
sealed class BuildingsState {}

final class BuildingsInitial extends BuildingsState {}

class LoadingBuildingsState extends BuildingsState {}

class SuccessBuildingsState extends BuildingsState {}

class ErrorBuildingsState extends BuildingsState {}
