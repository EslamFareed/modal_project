import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_button/group_button.dart';
import 'package:modal_project/core/app_functions.dart';
import 'package:modal_project/views/admin/courses/models/course_model.dart';

import 'cubit/register_cubit.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final idController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final courses = ["Math", "Physics", "Biology", "Chemistry", "English"];
  final selectedCourses = <CourseModel>[];

  @override
  Widget build(BuildContext context) {
    RegisterCubit.get(context).getCourses();
    return Scaffold(
      appBar: AppBar(title: Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Image.asset("assets/images/icon.png", width: 150, height: 150),
                SizedBox(height: 20),
                _buildField("Name", nameController),
                _buildField("Email", emailController),
                _buildField("Phone", phoneController),
                _buildField("ID Number", idController),
                _buildField("Password", passwordController, isPassword: true),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Select Courses",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 10),
                GroupButton<CourseModel>(
                  isRadio: false,
                  onSelected: (value, index, isSelected) {
                    if (isSelected) {
                      selectedCourses.add(value);
                    } else {
                      selectedCourses.remove(value);
                    }
                  },
                  buttons: RegisterCubit.get(context).courses,
                  buttonTextBuilder: (selected, value, context) {
                    return value.name ?? "";
                  },
                ),

                SizedBox(height: 30),
                BlocConsumer<RegisterCubit, RegisterState>(
                  listener: (context, state) {
                    if (state is RegisterSuccess) {
                      context.showSuccessSnack("Registration Successful");
                      Navigator.pop(context);
                    } else if (state is RegisterError) {
                      context.showErrorSnack(state.message);
                    }
                  },
                  builder: (context, state) {
                    return state is RegisterLoading
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              if (selectedCourses.isEmpty) {
                                context.showErrorSnack(
                                  "Please select at least one course",
                                );
                                return;
                              }

                              RegisterCubit.get(context).registerStudent(
                                email: emailController.text,
                                password: passwordController.text,
                                name: nameController.text,
                                phone: phoneController.text,
                                idNumber: idController.text,
                                selectedCourses: selectedCourses,
                              );
                            }
                          },
                          child: Text("Register"),
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

  Widget _buildField(
    String label,
    TextEditingController controller, {
    bool isPassword = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        validator:
            (value) =>
                value == null || value.isEmpty ? '$label is required' : null,
      ),
    );
  }
}
