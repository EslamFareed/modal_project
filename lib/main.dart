import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:modal_project/cubits/login_cubit/login_cubit.dart';
import 'package:modal_project/views/admin/admins/cubit/admins_cubit.dart';
import 'package:modal_project/views/admin/buildings/cubit/buildings_cubit.dart';
import 'package:modal_project/views/admin/courses/cubit/courses_cubit.dart';
import 'package:modal_project/views/admin/students/cubit/students_cubit.dart';
import 'package:modal_project/views/instructor/assignments/cubit/assignments_cubit.dart';
import 'package:modal_project/views/splash_screen.dart';
import 'package:modal_project/views/student/register/cubit/register_cubit.dart';
import 'core/cache_helper.dart';
import 'firebase_options.dart';
import 'views/admin/instructors/cubit/instructors_cubit.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await CacheHelper.init();

  tz.initializeTimeZones();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  await requestNotificationPermission();

  runApp(const MyApp());
}

Future<void> requestNotificationPermission() async {
  if (Platform.isAndroid) {
    final androidPlugin =
        flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
    await androidPlugin?.requestNotificationsPermission();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LoginCubit()),
        BlocProvider(create: (context) => AdminsCubit()),
        BlocProvider(create: (context) => CoursesCubit()),
        BlocProvider(create: (context) => BuildingsCubit()),
        BlocProvider(create: (context) => StudentsCubit()),
        BlocProvider(create: (context) => InstructorsCubit()),
        BlocProvider(create: (context) => AssignmentsCubit()),
        BlocProvider(create: (context) => RegisterCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
        theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 8,
            centerTitle: true,
            titleTextStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
