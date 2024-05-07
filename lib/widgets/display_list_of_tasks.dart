import 'package:flatwork/providers/providers.dart';
import 'package:flatwork/utils/utils.dart';
import 'package:flatwork/widgets/widgets.dart';
import 'package:flutter/material.dart';
import '../config/routes/routes.dart';
import '../data/data.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DisplayListOfTasks extends StatelessWidget {
  const DisplayListOfTasks({
    super.key,
    required this.tasks,
    required this.ref
  });

  final List<Task> tasks;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final deviceSize = context.deviceSize;
    const emptyTasksMessage = "There is no task yet";

    return CommonContainer(
      height: deviceSize.height*0.68,
      color: context.colorScheme.onPrimary,
      child: tasks.isEmpty?
      Center(
        child: Text(
          emptyTasksMessage,
          style: context.textTheme.headlineSmall,
        ),
      )
          :
      ListView.separated(
        shrinkWrap: true,
        itemCount: tasks.length,
        itemBuilder: (ctx, index) {
          final task = tasks[index];

          return InkWell(
              onLongPress: () {
                //TODO: Delete Task
              },
              onTap: () {
                ref.read(taskIdProvider.notifier).state = task.id.toString();
                context.pushNamed(
                  RouteLocation.editTask,
                  pathParameters: {'taskId': task.id.toString()},
                );
              },
              child: TaskTile(
                  task: task,
                  onCompleted: (value){},
              )
          );
        }, separatorBuilder: (BuildContext context, int index) {
        return const Divider(thickness: 1.5,);
      },
      ),
    );
  }
}
