import 'package:flutter/material.dart';
import 'package:modal_project/core/app_functions.dart';
import 'package:modal_project/views/instructor/assignments/assignments_screen.dart';
import '../../core/app_drawer.dart';
import '../../core/cache_helper.dart';
import 'assignments/create_assignment_screen.dart';

class InstructorHomeScreen extends StatelessWidget {
  const InstructorHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tiles = [
      _InstructorItem(
        label: "Assignments",
        icon: Icons.assignment,
        onTap: () => context.goToPage(const AssignmentsScreen()),
        gradient: const [Color(0xFF8A00D4), Color(0xFFB044FF)],
      ),
      _InstructorItem(
        label: "Add Assignment",
        icon: Icons.add_circle_outline,
        onTap: () => context.goToPage(const CreateAssignmentScreen()),
        gradient: const [Color(0xFFFF0057), Color(0xFFFC567C)],
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Instructor Dashboard"),
        backgroundColor: const Color(0xFF8A00D4),
        foregroundColor: Colors.white,
      ),
      drawer: AppDrawer(label: "Instructor: ${CacheHelper.getName()}"),
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

class _InstructorItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final List<Color> gradient;

  const _InstructorItem({
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
              textAlign: TextAlign.center,
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
