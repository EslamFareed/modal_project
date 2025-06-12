import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_button/group_button.dart';
import 'package:modal_project/core/app_functions.dart';
import 'package:modal_project/views/admin/admin_home_screen.dart';
import 'package:modal_project/views/admin/courses/models/course_model.dart';
import 'package:modal_project/views/admin/instructors/cubit/instructors_cubit.dart';

class CreateInstructorScreen extends StatelessWidget {
  CreateInstructorScreen({super.key});

  final nameController = TextEditingController();
  final idController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final phoneController = TextEditingController();

  final globalKey = GlobalKey<FormState>();
  final controller = GroupButtonController();
  @override
  Widget build(BuildContext context) {
    InstructorsCubit.get(context).getCourses();
    return Scaffold(
      appBar: AppBar(title: Text("Create Instructor")),
      body: BlocConsumer<InstructorsCubit, InstructorsState>(
        listener: (context, state) {
          if (state is ErrorInstructorsState) {
            context.showErrorSnack("Error, Please try again");
          } else if (state is SuccessInstructorsState) {
            context.showSuccessSnack("Created Successfully");
            context.goOffAll(AdminHomeScreen());
          }
        },
        builder: (context, state) {
          return state is LoadingInstructorsState
              ? Center(child: CircularProgressIndicator())
              : Padding(
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
                              return "Id must be not empty";
                            }
                            return null;
                          },
                          controller: idController,
                          decoration: InputDecoration(
                            labelText: "Id",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Email must be not empty";
                            }
                            return null;
                          },
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: "Email",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Password must be not empty";
                            }
                            return null;
                          },
                          controller: passController,
                          decoration: InputDecoration(
                            labelText: "Password",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Phone must be not empty";
                            }
                            return null;
                          },
                          controller: phoneController,
                          decoration: InputDecoration(
                            labelText: "Phone",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text("Select Courses"),
                        GroupButton<CourseModel>(
                          isRadio: false,
                          controller: controller,
                          onSelected:
                              (v, index, isSelected) =>
                                  print('$index button is selected'),
                          buttons: InstructorsCubit.get(context).courses,
                          buttonTextBuilder: (selected, value, context) {
                            return value.name ?? "";
                          },
                        ),
                        SizedBox(height: 50),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              if ((globalKey.currentState?.validate() ??
                                      false) &&
                                  controller.selectedIndexes.isNotEmpty) {
                                InstructorsCubit.get(context).createInstructor(
                                  email: emailController.text,
                                  id: idController.text,
                                  name: nameController.text,
                                  pass: passController.text,
                                  phone: phoneController.text,
                                  coursesIds:
                                      controller.selectedIndexes.toList(),
                                );
                              } else {
                                context.showErrorSnack("Please enter all data");
                              }
                            },
                            child: Text(
                              "Create Instructror",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
        },
      ),
    );
  }
}
