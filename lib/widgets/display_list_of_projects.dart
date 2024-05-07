import 'package:flatwork/utils/utils.dart';
import 'package:flatwork/widgets/widgets.dart';
import 'package:flutter/material.dart';
import '../config/routes/routes.dart';
import '../data/data.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';

class DisplayListOfProjects extends StatelessWidget {
  const DisplayListOfProjects({
    super.key,
    required this.projects,
    required this.ref
  });

  final List<Project> projects;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final deviceSize = context.deviceSize;
    const emptyProjectsMessage = "There is no project yet";

    return CommonContainer(
      height: deviceSize.height*0.68,
      color: context.colorScheme.onPrimary,
      child: projects.isEmpty?
          Center(
            child: Text(
              emptyProjectsMessage,
              style: context.textTheme.headlineSmall,
            ),
          )
        :
        ListView.separated(
          shrinkWrap: true,
          itemCount: projects.length,
          itemBuilder: (ctx, index) {
            final project = projects[index];

            return InkWell(
              onLongPress: () {
                //TODO: Delete Project
              },
              onTap: () {
                ref.read(projectIdProvider.notifier).state = project.id.toString();
                context.pushNamed(
                  RouteLocation.viewProject,
                  pathParameters: {'projectId': project.id.toString()},
                );
              },
              child: ProjectTile(project: project)
            );
          }, separatorBuilder: (BuildContext context, int index) {
            return const Column(
              children: [
                Gap(10),
                Divider(thickness: 1.5,),
                Gap(10),
              ],
            );
        },
      ),
    );
  }
}
