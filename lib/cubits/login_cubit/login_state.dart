part of 'login_cubit.dart';

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}

class LoginLoadingState extends LoginState {}

class LoginStudentSuccessState extends LoginState {}
class LoginInstructorSuccessState extends LoginState {}
class LoginAdminSuccessState extends LoginState {}

class LoginErrorState extends LoginState {}