import 'package:flatwork/config/config.dart';
import 'package:flatwork/data/data.dart';
import 'package:flatwork/providers/providers.dart';
import 'package:flatwork/utils/utils.dart';
import 'package:flatwork/widgets/main_scaffold.dart';
import 'package:flatwork/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProjectScreen extends ConsumerStatefulWidget {
  static ProjectScreen builder(BuildContext context, GoRouterState state)
  => const ProjectScreen();
  const ProjectScreen({super.key});

  @override
  ConsumerState<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends ConsumerState<ProjectScreen> {

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // final futureRef = projectProvider.
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final deviceSize = context.deviceSize;

    //TODO: fetch all projects from the backend
    final projects = ref.watch(projectsProvider);

    return MainScaffold(
      child: Scaffold(
        body: CustomScrollView (
            slivers: [
              SliverAppBar(
                pinned: true,
                floating: true,
                expandedHeight: deviceSize.height*0.28,
                backgroundColor: Colors.white,
                flexibleSpace: FlexibleSpaceBar(
                  background: Column(
                    children: [
                      Container(
                        height: deviceSize.height*0.28,
                        width: deviceSize.width,
                        color: colors.primary,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.start,
                            //   children: [
                            //     IconButton(
                            //       icon: Icon(Icons.logout, color: colors.onPrimary,size: 30,),
                            //       onPressed: () {
                            //         ref.read(authProvider.notifier).logout();
                            //         context.pushNamed(RouteLocation.login);
                            //       },
                            //     ),
                            //   ],
                            // ),
                            const DisplayWhiteText(
                                text: 'Project List',
                                fontSize: 40
                            ),
                            // const Gap(50),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
                // section that takes the remaining space
              SliverToBoxAdapter(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      projects.when(
                        data: (projects) {
                          List<Project> projectsList = projects.map((e) => e).toList();
                          print(projectsList);
                          return DisplayListOfProjects(
                            projects: projectsList,
                            ref: ref,
                          );
                        },
                        //TODO: snakBar here
                        error: (error,s) => Text(error.toString()),
                        loading: () =>  const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
        ),
        floatingActionButton: SizedBox(
          width: deviceSize.width * 0.9,
          child: ElevatedButton(
              onPressed: () => context.push(RouteLocation.createProject),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: DisplayWhiteText(
                  text:'Create new Project',
                  fontSize: 20,
                ),
              )
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
