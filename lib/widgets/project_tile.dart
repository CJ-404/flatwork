import 'package:flatwork/data/data.dart';
import 'package:flatwork/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class ProjectTile extends StatelessWidget {
  const ProjectTile({super.key, required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    // decoration: BoxDecoration(
    //   color: Colors.amber.shade50,
    //   borderRadius: BorderRadius.circular(10),
    // ),
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        top: 10,
        bottom: 10,
        right: 10,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            project.title,
            style: context.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 25,
              fontFamily: GoogleFonts.akatab().fontFamily,
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
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Text(
          //       project.date,
          //       style: context.textTheme.headlineSmall?.copyWith(
          //         fontSize: 18,
          //       ),
          //     ),
          //     Text(
          //       project.time,
          //       style: context.textTheme.headlineSmall?.copyWith(
          //         fontSize: 18,
          //       ),
          //     )
          //   ],
          // )
        ],
      ),
    );
  }
}
