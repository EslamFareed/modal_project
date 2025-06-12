import 'package:flutter/material.dart';
import 'package:modal_project/core/app_functions.dart';

import '../../core/app_drawer.dart';
import '../../core/cache_helper.dart';

class InstructorHomeScreen extends StatelessWidget {
  const InstructorHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Instructror Dashboard")),
      drawer: AppDrawer(label: "Instructror : ${CacheHelper.getName()}"),
      body: ListView(
        children: [
          Card(
            child: ListTile(
              onTap: () {
                // context.goToPage(AdminsScreen());
              },
              title: Text("Assignments"),
              leading: Icon(Icons.dashboard),
              trailing: Icon(Icons.arrow_forward_ios, size: 15),
            ),
          ),
        ],
      ),
    );
  }
}
