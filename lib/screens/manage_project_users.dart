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
import 'package:path/path.dart';

import '../services/auth_services.dart';
import '../widgets/circular_progress_indicator.dart';

class ManageProjectUsers extends ConsumerWidget {
  static ManageProjectUsers builder(BuildContext context, GoRouterState state , String projectId)
  => ManageProjectUsers(
    projectId: projectId,
  );
  ManageProjectUsers({
    super.key,
    required this.projectId,
  });

  final String projectId;

  final TextEditingController _roleController = TextEditingController(text: "Project Manager");

  @override
  Widget build(BuildContext context, ref) {
    final colors = context.colorScheme;
    final deviceSize = context.deviceSize;
    // final projectIdState = ref.watch(projectIdProvider);
    final projectUsers2 = ref.watch(projectUserListProvider);
    final loading = ref.watch(loadingProvider);
    final projectState = ref.watch(projectProvider);
    final tasksState = ref.watch(tasksProvider);
    final currentUserData = ref.watch(userDataProvider);
    final scaffoldKey = GlobalKey<ScaffoldState>();


    return Scaffold(
      floatingActionButton: (currentUserData.value!["role"] == "Team Member")?
      SizedBox.shrink()
      :
      FloatingActionButton(
        onPressed: () async {
          final currentUserData = ref.watch(userDataProvider);
          // Implement your function to write a message to a new user
          try{
            final User? user = await showOverlayDialog(context,ref, projectUsers2);
            if(user != null && user.id.isNotEmpty)
              {
                ref.read(loadingProvider.notifier).state = true;
                try{
                  final result = await ApiServices().sendInvitation(user.id, projectId, currentUserData.value!["userId"]!, 2);
                  ref.read(loadingProvider.notifier).state = false;
                  if(result)
                  {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          // mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Invitation sent"),
                            SizedBox(width: 10),
                            Icon(Icons.check_box_outlined, color: Colors.black54),
                          ],
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                  else
                  {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          // mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Check your network connection"),
                            SizedBox(width: 10),
                            Icon( Icons.error_outline_rounded , color: Colors.black54),
                          ],
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
                catch(e) {
                  ref.read(loadingProvider.notifier).state = false;
                  print(e);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Internal server error"),
                          SizedBox(width: 10),
                          Icon( Icons.error_outline_rounded , color: Colors.black54),
                        ],
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
          }
          catch(e)
          {
            print(e.toString());
          }
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
                                  mainAxisAlignment: (userRole == "Manager" || userRole == "OWNER")? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.logout, color: colors.onPrimary,size: 30,),
                                      onPressed: () {
                                        ref.read(authProvider.notifier).logout();
                                        context.pushNamed(RouteLocation.login);
                                      },
                                    ),
                                    (userRole == "Manager" || userRole == "OWNER")?
                                    PopupMenuButton<String>(
                                      icon: const Icon(
                                        Icons.more_vert,
                                        color: Colors.white,
                                        size: 28,
                                      ),
                                      onSelected: (value) {
                                        if (value == 'Chat with Project Members') {
                                          context.pushNamed(
                                            RouteLocation.chat,
                                            pathParameters: {'projectId': project.id.toString()},
                                          );
                                        }
                                      },
                                      itemBuilder: (context) => [
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
                                  loading?
                                      Center(
                                        child: CircularProgressIndicator(),
                                      )
                                  :
                              ListView.separated(
                                shrinkWrap: true,
                                itemCount: projectUsers2.length,
                                itemBuilder: (ctx, index) {
                                  final user = projectUsers2[index];
                                  final userName = "${user.firstName} ${user.lastName}";
                                  final userId = user.id;
                                  final currentUserData = ref.watch(userDataProvider);
                                  _roleController.text = user.role!;

                                  return ListTile(
                                    leading: CircleAvatar(
                                      child: Text(userName[0]), // Show the first letter of the user's name
                                    ),
                                    title: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text.rich(TextSpan(
                                          children: [
                                            TextSpan(
                                              text: userName,
                                            ),
                                            // TextSpan(
                                            //   text: " (${user.email})",
                                            //   style: TextStyle(color: Colors.grey.shade700),
                                            // )
                                          ]
                                        )),
                                        Text(user.email, style: TextStyle(color: Colors.grey, fontSize: 14),),
                                        Text(user.role!, style: TextStyle(color: Colors.grey, fontSize: 14),),
                                      ],
                                    ),
                                    trailing: ((userId == currentUserData.value!["userId"]) || currentUserData.value!["role"] != "OWNER")?
                                    SizedBox.shrink()
                                        :
                                    dotThree(context, ref, projectId, userId, user.role!), // Show a badge if there are new messages
                                    onTap: () {
                                      // do nothing
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

  Future<dynamic> showOverlayDialog(BuildContext context, WidgetRef ref, List<User> projectUsers) async {
    final deviceSize = context.deviceSize;
    TextEditingController searchController = TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(10),
          title: Text('Select an user'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Search Input Field
              TextField(
                controller: searchController,
                onChanged: (value) {
                  // update user list based on search input
                  ref.read(AllUserListProvider.notifier).filterAllUsers(value);
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
                  child: Consumer(
                      builder: (context, ref, child) {
                        final filteredUsers = ref.watch(AllUserListProvider);
                        
                        return (searchController.text == "")?
                            Center(
                              child: Text("start typing to see users"),
                            )
                        :
                        (filteredUsers.isEmpty)?
                          Center(
                            child: Text("Not found! Check again"),
                          )
                        :
                        ListView.separated(
                          shrinkWrap: true,
                          itemCount: filteredUsers.length,
                          itemBuilder: (ctx, index) {
                            final user = filteredUsers[index];

                            return ListTile(
                              title: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(user.firstName),
                                  Text(user.email, style: TextStyle(color: Colors.grey),),
                                ],
                              ),
                              onTap: () async {
                                Navigator.pop(context,user);
                              },
                              enabled: !projectUsers.any((projectUser) => projectUser.id == user.id),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const Divider(thickness: 1.0,);
                          },
                        );
                      }
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

  Widget dotThree(BuildContext context, WidgetRef ref, String projectId , String userId, String userRole) {
    final currentUserData = ref.watch(userDataProvider);

      return PopupMenuButton<String>(
        icon: const Icon(
          Icons.more_vert,
          color: Colors.black,
          size: 28,
        ),
        onSelected: (value) async {
          if (value == 'delete') {
            try{
              final result = await showDeleteOverlayDialog(context, ref, projectId, userId);
              if(result == "remove")
                {
                  final remove = await ApiServices().removeUserFromProject(projectId, currentUserData.value!["userId"]!, userId);
                  if(remove)
                    {
                      ref.invalidate(AllUserListProvider);
                      ref.invalidate(projectUserListProvider);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            // mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("User removed"),
                              SizedBox(width: 10),
                              Icon( Icons.check_box_outlined , color: Colors.black54),
                            ],
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  else{
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          // mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Internal server error"),
                            SizedBox(width: 10),
                            Icon( Icons.error_outline_rounded , color: Colors.black54),
                          ],
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
            }
            catch(e)
          {
            print(e.toString());
          }
          } else if (value == 'change role') {
            showRoleChangeOverlayDialog(context, ref, projectId, userId, userRole);
          }
        },
        itemBuilder: (context) => [
          const PopupMenuItem<String>(
            value: 'change role',
            child: Text('Change Role'),
          ),
          const PopupMenuItem<String>(
            value: 'delete',
            child: Text('Delete'),
          ),
        ],
      );
    }

  void showRoleChangeOverlayDialog(
      BuildContext context,WidgetRef ref, String projectId, String userId, String userRole) {

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change User Role'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: const Text('Team Member'),
                value: 'Team Member',
                selected: userRole == 'Team Member',
                groupValue: _roleController.text,
                onChanged: (String? value) {
                  if (value != null) {
                    _roleController.text = value;
                    // Rebuild the dialog to reflect the change.
                    Navigator.of(context).pop();
                    showRoleChangeOverlayDialog(context, ref, projectId, userId, userRole);
                  }
                },
              ),
              RadioListTile<String>(
                title: const Text('Project Manager'),
                value: 'Manager',
                selected: userRole == 'Manager',
                groupValue: _roleController.text,
                onChanged: (String? value) {
                  if (value != null) {
                    _roleController.text = value;
                    // Rebuild the dialog to reflect the change.
                    Navigator.of(context).pop();
                    showRoleChangeOverlayDialog(context, ref, projectId, userId, userRole);
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                  ref.invalidate(projectUserListProvider);
                  Navigator.pop(context);
                },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                try{
                  Navigator.pop(context);
                  ref.read(loadingProvider.notifier).state = true;
                  final role = _roleController.text == "Manager"? 1 : 2;
                  final ownerId = await AuthServices().getSavedUserId();
                  final result = await ApiServices().updateUserRole(ownerId, userId, projectId, role);
                  ref.read(loadingProvider.notifier).state = false;
                  if(result)
                    {
                      ref.invalidate(AllUserListProvider);
                      ref.invalidate(projectUserListProvider);
                    }
                  else{
                    ref.invalidate(AllUserListProvider);
                    ref.invalidate(projectUserListProvider);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          // mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Check your network connection"),
                            SizedBox(width: 10),
                            Icon( Icons.error_outline_rounded , color: Colors.black54),
                          ],
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                } catch (e)
                {
                  Navigator.pop(context);
                  ref.invalidate(AllUserListProvider);
                  ref.invalidate(projectUserListProvider);
                  ref.read(loadingProvider.notifier).state = false;
                  print(e.toString());
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(e.toString()?? "Internal server error"),
                          SizedBox(width: 10),
                          Icon( Icons.error_outline_rounded , color: Colors.black54),
                        ],
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<dynamic> showDeleteOverlayDialog(
      BuildContext context, WidgetRef ref, String projectId, String userId) {
    const String dummyUserName = 'John Doe'; // Replace with actual user name if available.

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Remove User'),
          content: Text('Are you sure you want to remove $dummyUserName from the project?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, "cancel"),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, 'remove');
              },
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );
  }

}


