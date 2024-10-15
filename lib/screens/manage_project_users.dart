import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flatwork/config/config.dart';
import 'package:flatwork/data/data.dart';
import 'package:flatwork/providers/providers.dart';
import 'package:flatwork/services/api_services.dart';
import 'package:flatwork/utils/utils.dart';
import 'package:flatwork/widgets/DisplayListOfChats.dart';
import 'package:flatwork/widgets/display_list_of_shared_files.dart';
import 'package:flatwork/widgets/main_scaffold.dart';
import 'package:flatwork/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/auth_services.dart';
import '../widgets/circular_progress_indicator.dart';

class ManageProjectUsers extends ConsumerWidget {
  static ManageProjectUsers builder(BuildContext context, GoRouterState state , String projectId)
  => ManageProjectUsers(
    projectId: projectId,
  );
  const ManageProjectUsers({
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

    // Dummy list of active chats with new message counts
    final List<Map<String, dynamic>> activeChats = [
      {'userName': 'Alice', 'newMessages': 2},
      {'userName': 'Bob', 'newMessages': 0},
      {'userName': 'Charlie', 'newMessages': 5},
      {'userName': 'David', 'newMessages': 1},
      {'userName': 'Eve', 'newMessages': 0},
    ];


    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implement your function to write a message to a new user
          // TODO: dialog to select a new user to add to the project
          showOverlayDialog(context,ref);
        },
        backgroundColor: colors.secondary, // Set the background color of the button
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
                              return
                                Row(
                                  mainAxisAlignment: (userRole == "manager")? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.logout, color: colors.onPrimary,size: 30,),
                                      onPressed: () {
                                        ref.read(authProvider.notifier).logout();
                                        context.pushNamed(RouteLocation.login);
                                      },
                                    ),
                                    (userRole == "manager")?
                                    PopupMenuButton<String>(
                                      icon: const Icon(
                                        Icons.more_vert,
                                        color: Colors.white,
                                        size: 28,
                                      ),
                                      onSelected: (value) {
                                        if (value == 'Manage Project Files') {
                                          showOverlayDialog(context, ref);
                                        } else if (value == 'Chat with Project Members') {
                                          context.pushNamed(
                                            RouteLocation.chat,
                                            pathParameters: {'projectId': project.id.toString()},
                                          );
                                        }
                                      },
                                      itemBuilder: (context) => [
                                        const PopupMenuItem<String>(
                                          value: 'Manage Project Files',
                                          child: Text('Manage Project Files'),
                                        ),
                                        const PopupMenuItem<String>(
                                          value: 'Chat with Project Members',
                                          child: Text('Chat with Project Members'),
                                        ),
                                      ],
                                    )
                                        :
                                    Container()
                                  ],
                                );
                            }
                          },
                        ),
                        DisplayWhiteText(
                            text: project.title,
                            fontSize: 32
                        ),
                        const DisplayWhiteText(
                            text: 'Manage members',
                            fontSize: 22
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 30.0, top: 0.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              CircularPercentageIndicator(percentage: project.progress),
                            ],
                          ),
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
                              CommonContainer(
                              height: deviceSize.height * 0.56,
                              color: context.colorScheme.onPrimary,
                              child:
                              ListView.separated(
                                shrinkWrap: true,
                                itemCount: activeChats.length,
                                itemBuilder: (ctx, index) {
                                  final chat = activeChats[index];
                                  final userName = chat['userName'];
                                  final newMessages = chat['newMessages'];

                                  return ListTile(
                                    leading: CircleAvatar(
                                      child: Text(userName[0]), // Show the first letter of the user's name
                                    ),
                                    title: Text(userName),
                                    trailing: const Icon(
                                      Icons.delete_outline,
                                      color: Colors.red,
                                    ), // Show a badge if there are new messages
                                    onTap: () {
                                      //TODO: remove user from the project
                                    },
                                  );
                                }, separatorBuilder: (BuildContext context, int index) {
                                return const Divider(thickness: 1.5,);
                              },
                              ),
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

  void showOverlayDialog(BuildContext context, WidgetRef ref) async {
    final deviceSize = context.deviceSize;
    TextEditingController searchController = TextEditingController();
    List<Map<String, String>> users = [
      {'id': '1', 'name': 'Alice'},
      {'id': '2', 'name': 'Bob'},
      {'id': '3', 'name': 'Charlie'},
      {'id': '4', 'name': 'David'},
      {'id': '5', 'name': 'Eve'},
    ];
    List<Map<String, String>> filteredUsers = List.from(users);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(10),
          title: Text('Select a user to chat with'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Search Input Field
              TextField(
                controller: searchController,
                onChanged: (value) {
                  // Update the filtered users based on the search query
                  filteredUsers = users
                      .where((user) =>
                      user['name']!
                          .toLowerCase()
                          .contains(value.toLowerCase()))
                      .toList();
                  // ref.read(_dummyStateProvider.state).state++;
                },
                decoration: InputDecoration(
                  hintText: 'Search user email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 5, horizontal: 10),
                ),
              ),
              const SizedBox(height: 10),
              // List of Users
              Expanded(
                child: CommonContainer(
                  height: deviceSize.height*0.4,
                  color: context.colorScheme.onPrimary,
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: filteredUsers.length,
                    itemBuilder: (ctx, index) {
                      final user = filteredUsers[index];

                      return ListTile(
                        title: Text(user['name']!),
                        onTap: () {
                          // Navigate to the inbox screen of the selected user
                          Navigator.pop(context); // Close the dialog
                          //navigate to inbox
                          context.pushNamed(
                            RouteLocation.inbox,
                            pathParameters: {
                              'projectId': projectId.toString(),
                              'userName': user['id'].toString(),
                              'userId': user['name']!.toString(),
                            },
                          );
                        },
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider(thickness: 1.0,);
                    },
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
