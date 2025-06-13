import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_project/core/app_functions.dart';
import 'package:url_launcher/url_launcher.dart';

import '../admin/buildings/cubit/buildings_cubit.dart';

class StudentBuildingsScreen extends StatelessWidget {
  const StudentBuildingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    BuildingsCubit.get(context).getBuildings();

    return Scaffold(
      appBar: AppBar(title: const Text("University Buildings")),
      body: BlocBuilder<BuildingsCubit, BuildingsState>(
        builder: (context, state) {
          if (state is LoadingBuildingsState) {
            return const Center(child: CircularProgressIndicator());
          }

          final buildings = BuildingsCubit.get(context).buildings;

          if (buildings.isEmpty) {
            return const Center(child: Text("No buildings found."));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: buildings.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = buildings[index];

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  leading: CircleAvatar(
                    radius: 24,
                    backgroundColor: const Color(0xFF8A00D4),
                    child: const Icon(Icons.location_city, color: Colors.white),
                  ),
                  title: Text(
                    item.name ?? "Building",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: const Text("Tap to navigate on Google Maps"),
                  trailing: const Icon(
                    Icons.directions_walk,
                    color: Colors.pinkAccent,
                  ),
                  onTap: () async {
                    final uri = Uri.parse(
                      "https://www.google.com/maps/dir/?api=1&destination=${item.lat},${item.long}&travelmode=walking",
                    );
                    if (!await launchUrl(
                      uri,
                      mode: LaunchMode.externalApplication,
                    )) {
                      context.showErrorSnack("Error launching Google Maps");
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
