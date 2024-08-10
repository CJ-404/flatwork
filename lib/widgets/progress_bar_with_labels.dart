import 'package:flutter/material.dart';
import 'package:flatwork/providers/task/task.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProgressBarWithLabels extends ConsumerWidget {
  const ProgressBarWithLabels({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the progressProvider to get the current value
    final progressValue = ref.watch(progressProvider);

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
              min: 0,
              max: 100,
              divisions: 100, // Allows selection of any percentage
              label: progressValue.round().toString(),
              onChanged: (double value) {
                // Update the progress value using state management
                ref.read(progressProvider.notifier).state = value;
              },
            ),
            // Labels for predefined points
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: predefinedPoints.map((point) {
                return GestureDetector(
                  onTap: () {
                    // Update the progress value to a predefined point
                    ref.read(progressProvider.notifier).state = point;
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