import 'package:flutter/material.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Contact Us")),
      body: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF8A00D4), Color(0xFFFF0057)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: const [
                Text(
                  "Get in Touch",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                ListTile(
                  leading: Icon(Icons.email),
                  title: Text("support@edudashboard.com"),
                ),
                ListTile(
                  leading: Icon(Icons.phone),
                  title: Text("+20 111 222 3333"),
                ),
                ListTile(
                  leading: Icon(Icons.location_on),
                  title: Text("Smart Village, Giza, Egypt"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
