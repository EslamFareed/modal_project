import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_button/group_button.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';

import '../../admin/courses/models/course_model.dart';
import 'cubit/assignments_cubit.dart';

class CreateAssignmentScreen extends StatefulWidget {
  const CreateAssignmentScreen({super.key});

  @override
  State<CreateAssignmentScreen> createState() => _CreateAssignmentScreenState();
}

class _CreateAssignmentScreenState extends State<CreateAssignmentScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController textController = TextEditingController();
  final TextEditingController courseNameController = TextEditingController();
  final TextEditingController courseCodeController = TextEditingController();

  DateTime? deadline;
  PlatformFile? fileUrl;
  final controller = GroupButtonController();

  @override
  void initState() {
    AssignmentsCubit.get(context).getCourses();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AssignmentsCubit, AssignmentsState>(
      listener: (context, state) {
        if (state is SuccessAssignmentsState) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("Assignment Created")));
          Navigator.pop(context);
        } else if (state is ErrorAssignmentsState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to create assignment")),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text("Create Assignment")),
          body:
              state is LoadingAssignmentsState
                  ? const Center(child: CircularProgressIndicator())
                  : Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        children: [
                          TextFormField(
                            controller: textController,
                            decoration: const InputDecoration(
                              labelText: "Assignment Text",
                            ),
                            validator:
                                (val) =>
                                    val == null || val.isEmpty
                                        ? "Required"
                                        : null,
                          ),
                          const SizedBox(height: 12),
                          ListTile(
                            title: Text(
                              "Deadline: ${deadline != null ? DateFormat.yMMMd().add_jm().format(deadline!) : "Not selected"}",
                            ),
                            trailing: const Icon(Icons.calendar_today),
                            onTap: () async {
                              final selected = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2100),
                              );
                              if (selected != null) {
                                final time = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                );
                                if (time != null) {
                                  setState(() {
                                    deadline = DateTime(
                                      selected.year,
                                      selected.month,
                                      selected.day,
                                      time.hour,
                                      time.minute,
                                    );
                                  });
                                }
                              }
                            },
                          ),
                          const Divider(),

                          const Text(
                            "Course Info",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          GroupButton<CourseModel>(
                            isRadio: true,
                            maxSelected: 1,
                            controller: controller,
                            onSelected:
                                (v, index, isSelected) =>
                                    print('$index button is selected'),
                            buttons: AssignmentsCubit.get(context).courses,
                            buttonTextBuilder: (selected, value, context) {
                              return value.name ?? "";
                            },
                          ),
                          Row(
                            children: [
                              ElevatedButton.icon(
                                onPressed: () async {
                                  final result = await FilePicker.platform
                                      .pickFiles(type: FileType.any);
                                  if (result != null) {
                                    setState(() {
                                      fileUrl = result.files.first;
                                    });
                                  }
                                },
                                icon: const Icon(Icons.upload_file),
                                label: const Text("Pick File"),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  fileUrl?.name ?? "No file selected",
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                if (deadline == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Please select a deadline"),
                                    ),
                                  );
                                  return;
                                }
                                if (fileUrl == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Please pick a file"),
                                    ),
                                  );
                                  return;
                                }
                                if (controller.selectedIndex == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Please Select Course"),
                                    ),
                                  );
                                  return;
                                }

                                AssignmentsCubit.get(context).createAssignment(
                                  text: textController.text,
                                  file: fileUrl!,
                                  deadline: deadline!,
                                  courseIndex: controller.selectedIndex!,
                                );
                              }
                            },
                            child: const Text("Create Assignment"),
                          ),
                        ],
                      ),
                    ),
                  ),
        );
      },
    );
  }
}
