import 'package:flutter/material.dart';
import 'package:modal_project/core/app_drawer.dart';
import 'package:modal_project/core/app_functions.dart';
import 'package:modal_project/core/cache_helper.dart';
import 'package:modal_project/views/instructor/assignments/cubit/assignments_cubit.dart';
import 'package:modal_project/views/student/about_us_screen.dart';
import 'package:modal_project/views/student/contact_us_screen.dart';
import 'package:modal_project/views/student/my_profile_screen.dart';
import 'package:modal_project/views/student/student_assignments_screen.dart';
import 'package:modal_project/views/student/student_buildings_screen.dart';

class StudentHomeScreen extends StatelessWidget {
  const StudentHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AssignmentsCubit.get(context).getStudentAssignments(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Student Dashboard")),
      drawer: AppDrawer(label: CacheHelper.getName()),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [
            _dashboardItem(
              context,
              title: "Buildings",
              icon: Icons.location_city_rounded,
              onTap: () => context.goToPage(const StudentBuildingsScreen()),
            ),
            _dashboardItem(
              context,
              title: "Assignments",
              icon: Icons.assignment,
              onTap: () => context.goToPage(const StudentAssignmentsScreen()),
            ),
            _dashboardItem(
              context,
              title: "My Profile",
              icon: Icons.person,
              onTap: () => context.goToPage(const MyProfileScreen()),
            ),
            _dashboardItem(
              context,
              title: "Contact Us",
              icon: Icons.contact_support_outlined,
              onTap: () => context.goToPage(const ContactUsScreen()),
            ),
            _dashboardItem(
              context,
              title: "About Us",
              icon: Icons.info_outline,
              onTap: () => context.goToPage(const AboutUsScreen()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dashboardItem(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF8A00D4), Color(0xFFFF0057)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.white),
              SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
