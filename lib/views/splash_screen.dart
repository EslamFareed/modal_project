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
    Future.delayed(Duration(seconds: 3), () {
      if (context.mounted) {
        context.offToPage(
          CacheHelper.isLogin()
              ? CacheHelper.getType() == 1
                  ? AdminHomeScreen()
                  : CacheHelper.getType() == 2
                  ? InstructorHomeScreen()
                  : CacheHelper.getType() == 3
                  ? StudentHomeScreen()
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset("assets/images/icon.png", width: 200, height: 200),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
