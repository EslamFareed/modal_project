import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_project/core/app_functions.dart';
import 'package:modal_project/views/admin/admin_home_screen.dart';
import 'package:modal_project/views/instructor/instructor_home_screen.dart';
import 'package:modal_project/views/student/student_home_screen.dart';

// import '../../../core/app_colors.dart';
import '../../../core/app_text_field.dart';
import '../cubits/login_cubit/login_cubit.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: context.screenHeight * .05),
                Text(
                  "Login",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: context.screenHeight * .05),

                //! ------------------- Email ------------------!
                AppTextField(
                  controller: emailController,
                  hint: "Email",
                  label: "Email",
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email is required";
                    }

                    return null;
                  },
                ),
                SizedBox(height: context.screenHeight * .05),

                //! ------------------- Password ------------------!
                AppTextField(
                  controller: passwordController,
                  hint: "Enter Your Password",
                  label: "Password",
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password is required";
                    }
                    if (value.length < 6) {
                      return "Password must be at least 6 characters";
                    }
                    return null;
                  },
                ),

                SizedBox(height: context.screenHeight * .05),

                //! ------------------- Login Button ------------------!
                BlocConsumer<LoginCubit, LoginState>(
                  listener: (context, state) {
                    print(state);
                    if (state is LoginAdminSuccessState) {
                      context.showSuccessSnack("Login successful");
                      context.goOffAll(AdminHomeScreen());
                    } else if (state is LoginStudentSuccessState) {
                      context.showSuccessSnack("Login successful");
                      context.goOffAll(StudentHomeScreen());
                    } else if (state is LoginInstructorSuccessState) {
                      context.showSuccessSnack("Login successful");
                      context.goOffAll(InstructorHomeScreen());
                    } else if (state is LoginErrorState) {
                      context.showErrorSnack("Login failed");
                    }
                  },
                  builder: (context, state) {
                    return state is LoginLoadingState
                        ? Center(child: CircularProgressIndicator())
                        : MaterialButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              LoginCubit.get(context).login(
                                email: emailController.text,
                                password: passwordController.text,
                              );
                            }
                          },
                          minWidth: context.screenWidth,
                          height: 50,
                          color: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            "Login",
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                  },
                ),
                SizedBox(height: 10),

                //! ------------------- Sign Up Link ------------------!
                Row(
                  spacing: 10,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?"),
                    InkWell(
                      onTap: () {
                        // context.goToPage(SignUpScreen());
                      },
                      child: Text(
                        "Sign up",
                        style: TextStyle(
                          // color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
