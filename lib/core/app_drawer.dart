import 'package:flutter/material.dart';
import 'package:modal_project/core/app_functions.dart';
import 'package:modal_project/core/cache_helper.dart';
import 'package:modal_project/views/login_screen.dart';

class AppDrawer extends StatelessWidget {
  final String label;

  const AppDrawer({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: null,
            accountEmail: Text(label, style: TextStyle(fontSize: 16)),
            currentAccountPicture: Image.asset(
              "assets/images/icon.png",
              width: 200,
              height: 200,
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () async {
              await CacheHelper.sharedPreferences.clear();
              context.goOffAll(LoginScreen());
            },
          ),
        ],
      ),
    );
  }
}
