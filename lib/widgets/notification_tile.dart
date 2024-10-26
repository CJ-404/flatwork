import 'package:flatwork/data/data.dart';
import 'package:flatwork/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class NotificationTile extends StatelessWidget {
  const NotificationTile({super.key, required this.message, this.onClose});

  final String message;
  final Function(bool?)? onClose;

  @override
  Widget build(BuildContext context) {
    final style = context.textTheme;
    final colors = context.colorScheme;

    return Row(
      children: [
        // CircleContainer(
        //   borderColor: task.category.color,
        //   color: task.category.color.withOpacity(backgroundOpacity),
        //   child: Icon(
        //     task.category.icon,
        //     color: task.category.color.withOpacity(iconOpacity),
        //   ),
        // ),
        const Gap(16),
        Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  message,
                  style: style.titleMedium?.copyWith(
                    fontSize: 17,
                  ),
                ),
                // Text(
                //   task.time,
                //   style: style.titleMedium?.copyWith(
                //     decoration: textDecoration,
                //   ),
                // ),
                IconButton(onPressed: (){
                      // onClose!(true);
                      // TODO: delete notification
                    },
                    icon: Icon(Icons.close, size: 20,))
              ],
            )),
      ],
    );
  }
}
