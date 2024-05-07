import 'package:flatwork/config/config.dart';
import 'package:flatwork/data/data.dart';
import 'package:flatwork/providers/project/project.dart';
import 'package:flatwork/providers/providers.dart';
import 'package:flatwork/utils/utils.dart';
import 'package:flatwork/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ViewProjectScreen extends ConsumerWidget {
  static ViewProjectScreen builder(BuildContext context, GoRouterState state , String projectId)
  => ViewProjectScreen(
    projectId: projectId,
  );
  const ViewProjectScreen({
    super.key,
    required this.projectId
  });

  final String projectId;

  @override
  Widget build(BuildContext context, ref) {
    final colors = context.colorScheme;
    final deviceSize = context.deviceSize;
    // final projectIdState = ref.watch(projectIdProvider);
    final projectState = ref.watch(projectProvider);
    final tasksState = ref.watch(tasksProvider);

    //ToDo: fetch project using project ID
    //TODO: fetch all tasks from backend
    final projectTitle = "project $projectId";

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: deviceSize.height*0.3,
                width: deviceSize.width,
                color: colors.secondary,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DisplayWhiteText(
                        text: projectTitle,
                        fontSize: 32
                    ),
                    const DisplayWhiteText(
                        text: 'Task List',
                        fontSize: 25
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
              top: 130,
              left: 0,
              right: 0,
              child: SafeArea(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // tasksState.when(
                      //     data: (tasksState) {
                      //       List<Task> tasksList = tasksState.map((e) => e).toList();
                      //       //TODO: add SingleChildScrollView here
                      //     },
                      //   // TODO: snakBar here
                      //       error: (error,s) => Text(error.toString()),
                      //       loading: () =>  const Center(
                      //         child: CircularProgressIndicator(),
                      //       ),
                      // ),
                      DisplayListOfTasks(
                        tasks: const [
                          Task(
                              id: 1,
                              title: 'Frontend Authentication',
                              description: "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s",
                              isCompleted: false,
                              assignedTeamMembers: [],
                          ),
                          Task(
                              id: 2,
                              title: 'Back end Authentication',
                              description: "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s",
                              isCompleted: false,
                              assignedTeamMembers: [],
                          ),
                          Task(
                            id: 3,
                            title: 'Create Complain',
                            description: "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s",
                            isCompleted: false,
                            assignedTeamMembers: [],
                          ),
                          Task(
                            id: 4,
                            title: 'View Complain',
                            description: "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s",
                            isCompleted: false,
                            assignedTeamMembers: [],
                          ),
                        ],
                        ref: ref,
                      ),
                      const Gap(20),
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
                    ],
                  ),
                ),
              )
          ),
        ],
      ),
    );
  }
}
