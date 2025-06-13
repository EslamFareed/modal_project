import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:modal_project/core/app_functions.dart';
import 'package:url_launcher/url_launcher.dart';

import '../instructor/assignments/cubit/assignments_cubit.dart';

class StudentAssignmentsScreen extends StatefulWidget {
  const StudentAssignmentsScreen({super.key});

  @override
  State<StudentAssignmentsScreen> createState() =>
      _StudentAssignmentsScreenState();
}

class _StudentAssignmentsScreenState extends State<StudentAssignmentsScreen> {
  @override
  void initState() {
    AssignmentsCubit.get(context).getStudentAssignments(context);
    super.initState();
  }

  PlatformFile? fileUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Assignments")),
      body: BlocConsumer<AssignmentsCubit, AssignmentsState>(
        listener: (context, state) {
          if (state is ErrorSendAnswerState) {
            context.showErrorSnack("Error,Please try again");
          } else if (state is SuccessSendAnswerState) {
            context.showSuccessSnack("Answer Sent Successfully");
          }
        },
        builder: (context, state) {
          if (state is LoadingAssignmentsState) {
            return const Center(child: CircularProgressIndicator());
          }

          final assignments = AssignmentsCubit.get(context).assignments;

          return ListView.builder(
            itemCount: assignments.length,
            itemBuilder: (context, index) {
              final task = assignments[index];

              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //! Assignment Text
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.assignment_turned_in,
                            color: Color(0xFF8A00D4),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              task.text ?? "No description",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      //! Attached File
                      if (task.file != null)
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.picture_as_pdf,
                                color: Colors.redAccent,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextButton(
                                  onPressed:
                                      () => _launchUrl(Uri.parse(task.file!)),
                                  child: const Text("Open Attached File"),
                                ),
                              ),
                            ],
                          ),
                        ),

                      const SizedBox(height: 10),

                      //! Deadline
                      if (task.deadline != null)
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_month,
                              color: Colors.blueAccent,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Deadline: ${DateFormat.yMMMEd().add_jm().format(task.deadline!.toDate())}",
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),

                      const SizedBox(height: 14),

                      //! Status / Upload
                      if (task.isAnswered)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: const [
                              Icon(
                                Icons.check_circle_outline,
                                color: Colors.green,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "You have answered this assignment",
                                style: TextStyle(color: Colors.green),
                              ),
                            ],
                          ),
                        )
                      else
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF8A00D4),
                                foregroundColor: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              fileUrl?.name ?? "No file selected yet",
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                            const SizedBox(height: 12),
                            if (fileUrl != null)
                              SizedBox(
                                width: double.infinity,
                                height: 45,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: const Color(0xFF8A00D4),
                                    side: const BorderSide(
                                      color: Color(0xFF8A00D4),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () {
                                    AssignmentsCubit.get(context).sendAnswer(
                                      file: fileUrl!,
                                      task: task,
                                      context: context,
                                    );
                                  },
                                  child:
                                      state is LoadingSendAnswerState
                                          ? const CircularProgressIndicator()
                                          : const Text(
                                            "Send Answer",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                ),
                              ),
                          ],
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _launchUrl(Uri url) async {
    // Use url_launcher package
    if (!await canLaunchUrl(url)) return;
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }
}
