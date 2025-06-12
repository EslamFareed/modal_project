part of 'instructors_cubit.dart';

@immutable
sealed class InstructorsState {}

final class InstructorsInitial extends InstructorsState {}

class LoadingInstructorsState extends InstructorsState {}

class SuccessInstructorsState extends InstructorsState {}

class SuccessInstructorsCoursesState extends InstructorsState {}

class ErrorInstructorsState extends InstructorsState {}
