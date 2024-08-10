import 'package:flatwork/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SharedFileTile extends StatelessWidget {
  const SharedFileTile({super.key, required this.fileName});

  final String fileName;

  @override
  Widget build(BuildContext context) {
    final style = context.textTheme;
    final colors = context.colorScheme;

    return Row(
      children: [
        const Gap(16),
        Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  style: style.titleMedium?.copyWith(
                    fontWeight: FontWeight.normal,
                    fontSize: 20,
                  ),
                ),
              ],
            )),
        IconButton(
          icon: Icon(Icons.download, color: colors.primary,size: 25,),
          onPressed: () {
          },
        ),
      ],
    );
  }
}
