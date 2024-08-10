import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flatwork/config/config.dart';
import 'package:flatwork/data/data.dart';
import 'package:flatwork/providers/providers.dart';
import 'package:flatwork/utils/utils.dart';
import 'package:flatwork/widgets/display_list_of_shared_files.dart';
import 'package:flatwork/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/auth_services.dart';
import '../widgets/circular_progress_indicator.dart';

class ViewProjectScreen extends ConsumerWidget {
  static ViewProjectScreen builder(BuildContext context, GoRouterState state , String projectId)
  => ViewProjectScreen(
    projectId: projectId,
  );
  ViewProjectScreen({
    super.key,
    required this.projectId,
  });

  final String projectId;

  @override
  Widget build(BuildContext context, ref) {
    final colors = context.colorScheme;
    final deviceSize = context.deviceSize;
    // final projectIdState = ref.watch(projectIdProvider);
    final projectState = ref.watch(projectProvider);
    final tasksState = ref.watch(tasksProvider);


    return Scaffold(
      body: Stack(
        children: [
          projectState.when(
              data: (projectState) {
                Project project = projectState;
                return Column(
                  children: [
                    Container(
                      height: deviceSize.height*0.35,
                      width: deviceSize.width,
                      color: colors.secondary,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 20.0, top: 5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CircularPercentageIndicator(percentage: 49.0),
                              ],
                            ),
                          ),
                          DisplayWhiteText(
                              text: project.title,
                              fontSize: 32
                          ),
                          const DisplayWhiteText(
                              text: 'Task List',
                              fontSize: 25
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit_document, color: colors.onPrimary,size: 30,),
                                onPressed: () {
                                  showOverlayDialog(context, ref);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
              error: (error,s) => Text(error.toString()),
              loading: () =>  const Center(
                child: CircularProgressIndicator(),
              ),
          ),
          Positioned(
              top: 200,
              left: 0,
              right: 0,
              child: SafeArea(
                child: tasksState.when(
                  data: (tasksState) {
                    List<Task> tasksList = tasksState.map((e) => e).toList();

                      return SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            DisplayListOfTasks(
                              tasks: tasksList,
                              ref: ref,
                            ),
                            const Gap(20),
                            FutureBuilder<String>(
                              future: AuthServices().getSavedUserRole(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Center(child: Text('Error: ${snapshot.error}'));
                                  // } else if (!snapshot.hasData || snapshot.data!['token'] == null) {
                                  //   return Center(child: Text('User data not found.'));
                                } else {
                                  final userRole = snapshot.data!;
                                  return (userRole == "manager")?
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: colors.secondary,
                                      ),
                                      onPressed: ()
                                      {
                                        context.pushNamed(
                                          RouteLocation.addTask,
                                          pathParameters: {'projectId':projectId},
                                        );
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: DisplayWhiteText(
                                          text:'Add new Task',
                                          fontSize: 20,
                                        ),
                                      )
                                  )
                                      : Container();
                                }
                              },
                            ),
                          ],
                        ),
                      );
                  },
                  // TODO: snakBar here
                  error: (error,s) => Text(error.toString()),
                  loading: () =>  const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
              )
          ),
        ],
      ),
    );
  }

  void _getPermissionOverlay(BuildContext context, WidgetRef ref, PlatformFile selectedFile) async {
    final userRole = await AuthServices().getSavedUserRole();
    final colors = context.colorScheme;
    showDialog(
      context: context,
      barrierDismissible: false, // dismiss when tapping outside
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          elevation: 16,
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'upload',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                const Divider(thickness: 1.5,),
                Text(
                  'Are you sure you want to upload ${selectedFile.name}?',
                  style: const TextStyle(fontSize: 16.0,),
                ),
                const Gap(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // upload file to the firebase & send link to the backend
                        // refresh getting shared files ref
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: const Text('Upload'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // remove selected file
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showOverlayDialog(BuildContext context, WidgetRef ref) async {
    final userRole = await AuthServices().getSavedUserRole();
    final colors = context.colorScheme;
    showDialog(
      context: context,
      barrierDismissible: true, // dismiss when tapping outside
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          elevation: 16,
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                (userRole == "manager")?
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Shared project files',
                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: Icon(Icons.add, color: colors.primary,size: 30,),
                      onPressed: () async {
                        FilePickerResult? result = await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['pdf','pptx','doc','docx'], // TODO: add more required types
                        );
                        if (result == null) return;
                        // File file = File(result.files.single.path!);
                        final selectedFile = result.files.first;
                        _getPermissionOverlay(context, ref, selectedFile);
                      },
                    ),
                  ],
                )
                    :
                const Text(
                  'Shared project files',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                const Divider(thickness: 1.5,),
                //list of shared files
                SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  // padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      DisplayListOfSharedFiles(sharedFiles: const ["asa","fathead"], ref: ref),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
