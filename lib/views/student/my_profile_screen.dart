import 'package:flutter/material.dart';
import 'package:modal_project/core/app_functions.dart';
import 'package:modal_project/core/cache_helper.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Profile")),
      body: Container(
        width: context.width,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF8A00D4), Color(0xFFFF0057)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: const Offset(0, 4),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //! Avatar
                const CircleAvatar(
                  radius: 45,
                  backgroundColor: Color(0xFF8A00D4),
                  child: Icon(Icons.person, size: 45, color: Colors.white),
                ),
                const SizedBox(height: 16),

                //! Info Cards
                _buildInfoRow("👤", "Name", CacheHelper.getName()),
                const SizedBox(height: 10),
                _buildInfoRow("📧", "Email", CacheHelper.getEmail()),
                const SizedBox(height: 10),
                _buildInfoRow("📞", "Phone", CacheHelper.getPhone()),
                const SizedBox(height: 10),
                _buildInfoRow("🆔", "Student ID", CacheHelper.getIdNumber()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String emoji, String label, String value) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(width: 10),
        Text(
          "$label:",
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 16, color: Colors.black54),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
