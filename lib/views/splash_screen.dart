import 'package:flutter/material.dart';
import 'package:modal_project/core/app_functions.dart';
import 'package:modal_project/views/admin/admin_home_screen.dart';
import 'package:modal_project/views/instructor/instructor_home_screen.dart';
import 'package:modal_project/views/student/student_home_screen.dart';
import '../core/cache_helper.dart';
import 'login_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  _goToScreen(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      if (context.mounted) {
        context.offToPage(
          CacheHelper.isLogin()
              ? CacheHelper.getType() == 1
                  ? const AdminHomeScreen()
                  : CacheHelper.getType() == 2
                  ? const InstructorHomeScreen()
                  : CacheHelper.getType() == 3
                  ? const StudentHomeScreen()
                  : LoginScreen()
              : LoginScreen(),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _goToScreen(context);
    return Scaffold(
      body: Container(
        width: context.width,
        height: context.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF8A00D4), Color(0xFFFF0057)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Image.asset("assets/images/icon.png", width: 160, height: 160),
              const SizedBox(height: 30),
              const Text(
                "Welcome to Edu Dashboard",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  letterSpacing: 1,
                ),
              ),
              const Spacer(),
              const Padding(
                padding: EdgeInsets.only(bottom: 40),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 3.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
