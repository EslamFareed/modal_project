import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/students_cubit.dart';

class StudentsScreen extends StatelessWidget {
  const StudentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    StudentsCubit.get(context).getStudents();
    return Scaffold(
      appBar: AppBar(title: Text("Students")),
      body: BlocBuilder<StudentsCubit, StudentsState>(
        builder: (context, state) {
          return state is LoadingStudentsState
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemBuilder: (context, index) {
                  final item = StudentsCubit.get(context).students[index];
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
                itemCount: StudentsCubit.get(context).students.length,
              );
        },
      ),
    );
  }
}
