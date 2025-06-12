part of 'students_cubit.dart';

@immutable
sealed class StudentsState {}

final class StudentsInitial extends StudentsState {}

class LoadingStudentsState extends StudentsState {}

class SuccessStudentsState extends StudentsState {}

class ErrorStudentsState extends StudentsState {}
