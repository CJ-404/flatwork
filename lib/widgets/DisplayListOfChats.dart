import 'package:flatwork/providers/providers.dart';
import 'package:flatwork/utils/utils.dart';
import 'package:flatwork/widgets/widgets.dart';
import 'package:flutter/material.dart';
import '../config/routes/routes.dart';
import '../data/data.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/auth_services.dart';

class DisplayListOfChats extends StatelessWidget {
  const DisplayListOfChats({
    super.key,
    required this.tasks,
    required this.projectId,
    required this.ref,
    required this.userId
  });

  final List<Task> tasks;
  final String projectId;
  final WidgetRef ref;
  final String userId;

  @override
  Widget build(BuildContext context) {
    final deviceSize = context.deviceSize;
    const emptyTasksMessage = "There are no tasks yet";
    var projectUsers = ref.watch(projectUserListProvider);
    projectUsers = [
      User(id: "ffffff", firstName: "Announcements", lastName: "", email: "ffffff", contact: "ffffff"),
      ...projectUsers
    ];
    projectUsers = projectUsers.where((user) => user.id != userId).toList();

    return FutureBuilder<String>(
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
            return CommonContainer(
              height: (userRole == "Manager")? deviceSize.height * 0.56 : deviceSize.height * 0.68,
              color: context.colorScheme.onPrimary,
              child: tasks.isEmpty ?
              Center(
                child: Text(
                  emptyTasksMessage,
                  style: context.textTheme.headlineSmall,
                ),
              )
                  :
              ListView.separated(
                shrinkWrap: true,
                itemCount: projectUsers.length,
                itemBuilder: (ctx, index) {
                  final chat = projectUsers[index];
                  final userName = "${chat.firstName} ${chat.lastName}";
                  final newMessages = 0; //chat.messages!;

                  return ListTile(
                        leading: CircleAvatar(
                          child: Text(userName[0]), // Show the first letter of the user's name
                        ),
                        title: Text(userName),
                        trailing: newMessages > 0
                        ? CircleAvatar(
                          backgroundColor: Colors.red,
                          radius: 12,
                          child: Text(
                            newMessages.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        )
                            : null, // Show a badge if there are new messages
                        onTap: () async {
                          final userId = await AuthServices().getSavedUserId();
                          context.pushNamed(
                            RouteLocation.inbox,
                            pathParameters: {
                              'projectId': projectId.toString(),
                              'receiverName' : userName.toString(),
                              'receiverId' : chat.id,
                              'userId' : userId.toString(),
                            },
                          );
                        },
                  );
                }, separatorBuilder: (BuildContext context, int index) {
                return const Divider(thickness: 1.5,);
              },
              ),
            );
          }
        }
    );
  }
}
