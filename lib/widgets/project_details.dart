import 'package:flatwork/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flatwork/data/data.dart';
import 'package:gap/gap.dart';

class ProjectDetails extends StatelessWidget {
  const ProjectDetails({
    super.key,
    required this.project
  });

  final Project project;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        top: 30,
        bottom: 10,
        right: 16,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              project.title,
              style: context.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
          ),
          const Gap(5),
          Center(
            child: Text(
              project.description,
              style: context.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 17,
              ),
            ),
          ),
          // const Gap(10),
          // Text(
          //   "Project deadline Date : ${project.date}",
          //   style: context.textTheme.headlineSmall?.copyWith(
          //     fontSize: 18,
          //     fontWeight: FontWeight.w600,
          //   ),
          // ),
          // Text(
          //   "Project deadline Date : ${project.time}",
          //   style: context.textTheme.headlineSmall?.copyWith(
          //     fontSize: 18,
          //     fontWeight: FontWeight.w600,
          //   ),
          // ),
        ],
      ),
    );
  }
}
