import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_project/core/app_functions.dart';
import 'package:modal_project/views/admin/admin_home_screen.dart';

import 'cubit/courses_cubit.dart';

class CreateCourseScreen extends StatelessWidget {
  CreateCourseScreen({super.key});

  final nameController = TextEditingController();
  final codeController = TextEditingController();

  final globalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Course")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: globalKey,
            child: Column(
              children: [
                SizedBox(height: 50),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Name must be not empty";
                    }
                    return null;
                  },
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Code must be not empty";
                    }
                    return null;
                  },
                  controller: codeController,
                  decoration: InputDecoration(
                    labelText: "Code",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                SizedBox(height: 50),
                BlocConsumer<CoursesCubit, CoursesState>(
                  listener: (context, state) {
                    if (state is ErrorCoursesState) {
                      context.showErrorSnack("Error, Please try again");
                    } else if (state is SuccessCoursesState) {
                      context.showSuccessSnack("Created Successfully");
                      context.goOffAll(AdminHomeScreen());
                    }
                  },
                  builder: (context, state) {
                    return state is LoadingCoursesState
                        ? Center(child: CircularProgressIndicator())
                        : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              if (globalKey.currentState?.validate() ?? false) {
                                CoursesCubit.get(context).createCourse(
                                  nameController.text,
                                  codeController.text,
                                );
                              }
                            },
                            child: Text(
                              "Create Course",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
