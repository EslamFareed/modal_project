import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_project/core/app_functions.dart';

import 'create_instructor_screen.dart';
import 'cubit/instructors_cubit.dart';

class InstructorsScreen extends StatelessWidget {
  const InstructorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    InstructorsCubit.get(context).getInstructors();
    return Scaffold(
      appBar: AppBar(
        title: Text("Instructors"),
        actions: [
          IconButton(
            onPressed: () {
              context.goToPage(CreateInstructorScreen());
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: BlocBuilder<InstructorsCubit, InstructorsState>(
        builder: (context, state) {
          return state is LoadingInstructorsState
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemBuilder: (context, index) {
                  final item = InstructorsCubit.get(context).instructors[index];
                  return Card(
                    child: ListTile(
                      title: Text("name : ${item.name}"),
                      subtitle: Text("""
email : ${item.email ?? ""}
phone : ${item.phone ?? ""}
id : ${item.idNumber ?? ""}
courses : ${item.courses!.values.map((e) => e.name)}"""),
                    ),
                  );
                },
                itemCount: InstructorsCubit.get(context).instructors.length,
              );
        },
      ),
    );
  }
}
