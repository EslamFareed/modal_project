import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_project/core/app_functions.dart';

import 'create_admin_screen.dart';
import 'cubit/admins_cubit.dart';

class AdminsScreen extends StatelessWidget {
  const AdminsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AdminsCubit.get(context).getAdmins();
    return Scaffold(
      appBar: AppBar(
        title: Text("Admins"),
        actions: [
          IconButton(
            onPressed: () {
              context.goToPage(CreateAdminScreen());
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: BlocBuilder<AdminsCubit, AdminsState>(
        builder: (context, state) {
          return state is LoadingAdminsState
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemBuilder: (context, index) {
                  final item = AdminsCubit.get(context).admins[index];
                  return Card(
                    child: ListTile(
                      leading: Text("${index + 1}"),
                      title: Text(item.email ?? ""),
                    ),
                  );
                },
                itemCount: AdminsCubit.get(context).admins.length,
              );
        },
      ),
    );
  }
}
