import 'package:flatwork/config/config.dart';
import 'package:flatwork/data/data.dart';
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


    return Scaffold(
      body: Stack(
        children: [
          projectState.when(
              data: (projectState) {
                Project project = projectState;
                return Column(
                  children: [
                    Container(
                      height: deviceSize.height*0.3,
                      width: deviceSize.width,
                      color: colors.secondary,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DisplayWhiteText(
                              text: project.title,
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
                );
              },
              error: (error,s) => Text(error.toString()),
              loading: () =>  const Center(
                child: CircularProgressIndicator(),
              ),
          ),
          Positioned(
              top: 130,
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
}
