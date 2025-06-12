import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_project/core/app_functions.dart';
import 'package:url_launcher/url_launcher.dart';

import 'create_building_screen.dart';
import 'cubit/buildings_cubit.dart';

class BuildingsScreen extends StatelessWidget {
  const BuildingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    BuildingsCubit.get(context).getBuildings();
    return Scaffold(
      appBar: AppBar(
        title: Text("Buildings"),
        actions: [
          IconButton(
            onPressed: () {
              context.goToPage(CreateBuildingScreen());
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: BlocBuilder<BuildingsCubit, BuildingsState>(
        builder: (context, state) {
          return state is LoadingBuildingsState
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemBuilder: (context, index) {
                  final item = BuildingsCubit.get(context).buildings[index];
                  return Card(
                    child: ListTile(
                      title: Text(item.name ?? ""),
                      onTap: () async {
                        Uri uri = Uri.parse(
                          "https://www.google.com/maps/dir/?api=1&destination=${item.lat},${item.long}&travelmode=walking",
                        );
                        if (!await launchUrl(
                          uri,
                          mode: LaunchMode.externalApplication,
                        )) {
                          context.showErrorSnack("Error, Please try again");
                        }
                      },
                    ),
                  );
                },
                itemCount: BuildingsCubit.get(context).buildings.length,
              );
        },
      ),
    );
  }
}
