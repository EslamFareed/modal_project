import 'package:flutter/material.dart';
import 'package:modal_project/core/app_functions.dart';
import 'package:modal_project/core/cache_helper.dart';
import 'package:modal_project/views/admin/buildings/buildings_screen.dart';
import 'package:modal_project/views/admin/courses/courses_screen.dart';
import 'package:modal_project/views/admin/instructors/instructors_screen.dart';
import 'package:modal_project/views/admin/students/students_screen.dart';

import '../../core/app_drawer.dart';
import 'admins/admins_screen.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dashboard")),
      drawer: AppDrawer(label: CacheHelper.getEmail()),
      body: ListView(
        children: [
          Card(
            child: ListTile(
              onTap: () {
                context.goToPage(AdminsScreen());
              },
              title: Text("Admins"),
              leading: Icon(Icons.dashboard),
              trailing: Icon(Icons.arrow_forward_ios, size: 15),
            ),
          ),
          Card(
            child: ListTile(
              onTap: () {
                context.goToPage(CoursesScreen());
              },
              title: Text("Courses"),
              leading: Icon(Icons.dashboard),
              trailing: Icon(Icons.arrow_forward_ios, size: 15),
            ),
          ),
          Card(
            child: ListTile(
              onTap: () {
                context.goToPage(BuildingsScreen());
              },
              title: Text("Building"),
              leading: Icon(Icons.dashboard),
              trailing: Icon(Icons.arrow_forward_ios, size: 15),
            ),
          ),
          Card(
            child: ListTile(
              onTap: () {
                context.goToPage(StudentsScreen());
              },
              title: Text("Students"),
              leading: Icon(Icons.dashboard),
              trailing: Icon(Icons.arrow_forward_ios, size: 15),
            ),
          ),
          Card(
            child: ListTile(
              onTap: () {
                context.goToPage(InstructorsScreen());
              },
              title: Text("Instructors"),
              leading: Icon(Icons.dashboard),
              trailing: Icon(Icons.arrow_forward_ios, size: 15),
            ),
          ),
        ],
      ),
    );
  }
}
