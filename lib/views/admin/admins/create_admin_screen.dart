import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_project/core/app_functions.dart';
import 'package:modal_project/views/admin/admin_home_screen.dart';

import 'cubit/admins_cubit.dart';

class CreateAdminScreen extends StatelessWidget {
  CreateAdminScreen({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final globalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Admin")),
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
                      return "Email must be not empty";
                    }
                    return null;
                  },
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    prefixIcon: Icon(Icons.email),
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
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: "Password",
                    prefixIcon: Icon(Icons.security),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                SizedBox(height: 50),
                BlocConsumer<AdminsCubit, AdminsState>(
                  listener: (context, state) {
                    if (state is ErrorAdminsState) {
                      context.showErrorSnack("Error, Please login again");
                    } else if (state is SuccessAdminsState) {
                      context.showSuccessSnack("Created Successfully");
                      context.goOffAll(AdminHomeScreen());
                    }
                  },
                  builder: (context, state) {
                    return state is LoadingAdminsState
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
                                AdminsCubit.get(context).createAdmin(
                                  emailController.text,
                                  passwordController.text,
                                );
                              }
                            },
                            child: Text(
                              "Create Admin",
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
