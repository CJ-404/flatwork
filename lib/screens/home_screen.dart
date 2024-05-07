import 'package:flatwork/config/config.dart';
import 'package:flatwork/data/data.dart';
import 'package:flatwork/providers/providers.dart';
import 'package:flatwork/utils/utils.dart';
import 'package:flatwork/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  static HomeScreen builder(BuildContext context, GoRouterState state)
    => const HomeScreen();
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colorScheme;
    final deviceSize = context.deviceSize;

    //TODO: fetch all projects from the backend
    final projects = ref.watch(projectsProvider);

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: deviceSize.height*0.3,
                width: deviceSize.width,
                color: colors.primary,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DisplayWhiteText(
                        text: 'Project List',
                        fontSize: 40
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
                      // projects.when(
                      //     data: (projects) {
                      //       List<Project> projectsList = projects.map((e) => e).toList();
                      //       return DisplayListOfProjects(
                      //         projects: projectsList,
                      //         ref: ref,
                      //       );
                      //     },
                      //   //TODO: snakBar here
                      //     error: (error,s) => Text(error.toString()),
                      //     loading: () =>  const Center(
                      //       child: CircularProgressIndicator(),
                      //     ),
                      // ),
                      DisplayListOfProjects(
                        projects: const [
                          Project(
                              id: 1,
                              title: 'Geto Mobile Project',
                              description: "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s",
                          ),
                          Project(
                            id: 2,
                              title: 'Geto Web Project',
                              description: "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s",
                          ),
                          Project(
                              id: 3,
                              title: 'Geto Web Project',
                              description: "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s",
                          ),
                          Project(
                              id: 4,
                              title: 'Geto Web Project',
                              description: "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s",
                          ),
                          Project(
                              id: 5,
                              title: 'Geto Web Project',
                              description: "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s",
                          ),
                        ],
                        ref: ref,
                      ),
                      const Gap(20),
                      ElevatedButton(
                          onPressed: () => context.push(RouteLocation.createProject),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: DisplayWhiteText(
                              text:'Create new Project',
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
