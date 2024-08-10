import 'package:flutter/material.dart';

class CircularPercentageIndicator extends StatelessWidget {
  final double percentage;

  const CircularPercentageIndicator({super.key, required this.percentage});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Background circle for progress
        SizedBox(
          width: 60,
          height: 60,
          child: CircularProgressIndicator(
            value: percentage / 100,
            strokeWidth: 8.0,
            backgroundColor: Colors.grey.shade300,
            valueColor: (percentage < 30.0 )? const AlwaysStoppedAnimation<Color>(Colors.orange)
                : (percentage < 50.0 )? const AlwaysStoppedAnimation<Color>(Colors.orangeAccent)
                  :(percentage < 80.0 )? const AlwaysStoppedAnimation<Color>(Colors.blue)
                    : const AlwaysStoppedAnimation<Color>(Colors.green),
          ),
        ),
        // Text to show percentage in center
        Text(
          '${percentage.toStringAsFixed(0)}%',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
