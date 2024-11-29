import 'package:flatwork/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:flatwork/providers/task/task.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/project/projects_provider.dart';

class ProgressBarWithLabels extends ConsumerWidget {
  const ProgressBarWithLabels({super.key,required this.taskId, required this.editAccess});

  final String taskId;
  final bool editAccess;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the progressProvider to get the current value
    final progressValue = ref.watch(taskProgressProvider);

    // Define predefined points
    final List<double> predefinedPoints = [0, 25, 50, 75, 100];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // Display the Slider
            Slider(
              value: progressValue,
              activeColor: (progressValue < 30.0 )? Colors.orange
                  : (progressValue < 50.0 )? Colors.orangeAccent
                  :(progressValue < 80.0 )? Colors.blue
                  : Colors.green,
              min: 0,
              max: 100,
              divisions: 100, // Allows selection of any percentage
              label: progressValue.round().toString(),
              onChanged: (double value) async {
                if(editAccess) {
                  ref.invalidate(userCalendarTasksProvider);
                  // Update the progress value using state management
                  try {
                    print("new progress updated: $value");
                    final result = await ApiServices().updateTaskProgress(
                        taskId, value);
                    ref
                        .read(taskProgressProvider.notifier)
                        .state = value;
                    ref.invalidate(taskProvider);
                    ref.invalidate(projectProvider);
                    print("updated progress!");
                  }
                  catch (e) {
                    //failed
                    print("updated progress failed: $e");
                  }
                }
              },
            ),
            // Labels for predefined points
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: predefinedPoints.map((point) {
                return GestureDetector(
                  onTap: () async {
                    // Update the progress value to a predefined point
                    try{
                      print("new progress updated: $point");
                      final result = await ApiServices().updateTaskProgress(taskId, point);
                      ref.read(taskProgressProvider.notifier).state = point;
                      ref.invalidate(tasksProvider);
                      ref.invalidate(projectProvider);
                      print("updated progress!");
                    }
                    catch (e){
                      //failed
                      print("updated progress failed: $e");
                    }
                  },
                  child: Text(
                    '${point.toStringAsFixed(0)}%',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ],
    );
  }
}