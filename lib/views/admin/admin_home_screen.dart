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
    final tiles = [
      _DashboardItem(
        label: "Admins",
        icon: Icons.admin_panel_settings,
        onTap: () => context.goToPage(const AdminsScreen()),
        gradient: const [Color(0xFF8A00D4), Color(0xFFBC00B5)],
      ),
      _DashboardItem(
        label: "Courses",
        icon: Icons.menu_book,
        onTap: () => context.goToPage(const CoursesScreen()),
        gradient: const [Color(0xFFFF0057), Color(0xFFFA3C9F)],
      ),
      _DashboardItem(
        label: "Buildings",
        icon: Icons.location_city,
        onTap: () => context.goToPage(const BuildingsScreen()),
        gradient: const [Color(0xFF8A00D4), Color(0xFF5E00A1)],
      ),
      _DashboardItem(
        label: "Students",
        icon: Icons.school,
        onTap: () => context.goToPage(const StudentsScreen()),
        gradient: const [Color(0xFFFF0057), Color(0xFFFC567C)],
      ),
      _DashboardItem(
        label: "Instructors",
        icon: Icons.person_outline,
        onTap: () => context.goToPage(const InstructorsScreen()),
        gradient: const [Color(0xFF8A00D4), Color(0xFFB044FF)],
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        backgroundColor: const Color(0xFF8A00D4),
        foregroundColor: Colors.white,
      ),
      drawer: AppDrawer(label: CacheHelper.getEmail()),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: tiles.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.1,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemBuilder: (context, index) => tiles[index],
        ),
      ),
    );
  }
}

class _DashboardItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final List<Color> gradient;

  const _DashboardItem({
    required this.label,
    required this.icon,
    required this.onTap,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(2, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Colors.white),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
