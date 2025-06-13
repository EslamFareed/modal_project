import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'cubit/assignments_cubit.dart';

class AssignmentsScreen extends StatelessWidget {
  const AssignmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AssignmentsCubit.get(context).getAssignments();

    return Scaffold(
      appBar: AppBar(title: const Text("Assignments")),
      body: BlocBuilder<AssignmentsCubit, AssignmentsState>(
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
                margin: const EdgeInsets.all(10),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "📄 Assignment: ${task.text ?? "No description"}",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),

                      if (task.file != null)
                        TextButton.icon(
                          onPressed: () {
                            // Open link in browser
                            _launchUrl(Uri.parse(task.file!));
                          },
                          icon: const Icon(Icons.picture_as_pdf),
                          label: const Text("Open Attached File"),
                        ),

                      if (task.deadline != null)
                        Text(
                          "📅 Deadline: ${DateFormat.yMMMEd().add_jm().format(task.deadline!.toDate())}",
                        ),

                      const SizedBox(height: 8),
                      Text("👨‍🏫 Instructor ID: ${task.instructor}"),

                      const Divider(),

                      if (task.course != null && task.course!.isNotEmpty) ...[
                        Text(
                          "📚 Courses:",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        ...task.course!.values.map(
                          (course) => Padding(
                            padding: const EdgeInsets.only(left: 8, top: 4),
                            child: Text(
                              "- ${course.name} (Code: ${course.code})",
                            ),
                          ),
                        ),
                      ],

                      const Divider(),

                      if (task.answers != null && task.answers!.isNotEmpty) ...[
                        Text(
                          "🧑‍🎓 Student Answers:",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        ...task.answers!.entries.map((entry) {
                          final answer = entry.value;

                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 6.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ExpansionTile(
                              leading: const Icon(Icons.person),
                              title: Text(answer.name ?? 'Unnamed Student'),
                              subtitle: Text("ID: ${answer.id ?? "N/A"}"),
                              childrenPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("📧 Email: ${answer.email ?? 'N/A'}"),
                                    const SizedBox(height: 4),
                                    Text("📱 Phone: ${answer.phone ?? 'N/A'}"),
                                    const SizedBox(height: 8),
                                    if (answer.answer != null)
                                      TextButton.icon(
                                        onPressed: () {
                                          _launchUrl(Uri.parse(answer.answer!));
                                        },
                                        icon: const Icon(Icons.picture_as_pdf),
                                        label: const Text("Open Attached File"),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
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
