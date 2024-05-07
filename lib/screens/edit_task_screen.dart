import 'dart:ffi';

import 'package:flatwork/data/data.dart';
import 'package:flatwork/utils/utils.dart';
import 'package:flatwork/widgets/select_team_member.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';

import '../config/routes/routes.dart';
import '../widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flatwork/providers/providers.dart';

class EditTaskScreen extends ConsumerWidget {
  static EditTaskScreen builder(BuildContext context, GoRouterState state, String taskId)
  => EditTaskScreen(taskId: taskId);
  const EditTaskScreen({super.key, required this.taskId});

  final String taskId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //TODO: fetch task from task ID
    // final taskIdState = ref.watch(taskIdProvider);
    // final task = ref.watch(taskProvider);
    Task task = Task(
        id: int.parse(taskId),
        title: 'FetchedTask',
        description: "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s",
        assignedTeamMembers : const [
          User(
              id: 1,
              firstName: 'kasun',
              lastName: 'gajanayaka',
              email: 'kasunGaje@gmail.com',
              contact: '0781232345'
          ),
          User(
              id: 2,
              firstName: 'kasun',
              lastName: 'gajanayaka',
              email: 'kasunGaje@gmail.com',
              contact: '0781232345'
          ),
          User(
              id: 3,
              firstName: 'kasun',
              lastName: 'gajanayaka',
              email: 'kasunGaje@gmail.com',
              contact: '0781232345'
          ),
          User(
              id: 4,
              firstName: 'kasun',
              lastName: 'gajanayaka',
              email: 'kasunGaje@gmail.com',
              contact: '0781232345'
          ),
        ],
        isCompleted: false,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: DisplayWhiteText(text: "${task.title} $taskId", fontSize: 20,),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20.0),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 16,
              top: 10,
              bottom: 10,
              right: 10,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Task description",
                  style: context.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                const Divider(
                  thickness: 1,
                  color: Colors.black,
                ),
                Text(
                  task.description,
                  style: context.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
                const Gap(30),
                Text(
                  "Team Mates",
                  style: context.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                const Divider(
                  thickness: 1,
                  color: Colors.black,
                ),
                SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      DisplayListOfUsers(
                        assignedUsers: task.assignedTeamMembers,
                      ),
                      const Gap(20),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.cyan,
                          ),
                          onPressed: () async {
                            ref.read(userFilterProvider.notifier).state = "";
                            await showModalBottomSheet(
                              // showDragHandle: true,
                              context: context,
                              builder: (ctx) {
                                return SelectTeamMember(assignedMembers: task.assignedTeamMembers,);
                              },
                            );
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: DisplayWhiteText(
                              text:'Assign a team member',
                              fontSize: 20,
                            ),
                          )
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
