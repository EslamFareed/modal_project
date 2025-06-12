import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_project/core/app_functions.dart';

import 'create_course_screen.dart';
import 'cubit/courses_cubit.dart';

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    CoursesCubit.get(context).getCourses();
    return Scaffold(
      appBar: AppBar(
        title: Text("Courses"),
        actions: [
          IconButton(
            onPressed: () {
              context.goToPage(CreateCourseScreen());
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: BlocBuilder<CoursesCubit, CoursesState>(
        builder: (context, state) {
          return state is LoadingCoursesState
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemBuilder: (context, index) {
                  final item = CoursesCubit.get(context).courses[index];
                  return Card(
                    child: ListTile(
                      title: Text(item.name ?? ""),
                      subtitle: Text(item.code ?? ""),
                    ),
                  );
                },
                itemCount: CoursesCubit.get(context).courses.length,
              );
        },
      ),
    );
  }
}
