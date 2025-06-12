part of 'admins_cubit.dart';

@immutable
sealed class AdminsState {}

final class AdminsInitial extends AdminsState {}


class LoadingAdminsState extends AdminsState{}
class SuccessAdminsState extends AdminsState{}
class ErrorAdminsState extends AdminsState{}