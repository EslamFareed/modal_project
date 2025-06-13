part of 'assignments_cubit.dart';

@immutable
sealed class AssignmentsState {}

final class AssignmentsInitial extends AssignmentsState {}

class LoadingAssignmentsState extends AssignmentsState {}

class SuccessAssignmentsState extends AssignmentsState {}

class ErrorAssignmentsState extends AssignmentsState {}

class SuccessAssignmentCoursesState extends AssignmentsState {}
