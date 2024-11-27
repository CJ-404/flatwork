import 'package:flatwork/data/data.dart';
import 'package:flatwork/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../config/routes/route_location.dart';

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
            child: Container(
              height: 40,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      //open overlay
                      _showNotificationDetailsOverlay(context);
                    },
                    child: Text(
                      message,
                      style: style.titleMedium?.copyWith(
                        fontSize: 17,
                      ),
                    ),
                  ),
                  Text("12.34", style: Theme.of(context).textTheme.bodyLarge,),
                  // IconButton(onPressed: (){
                  //       // onClose!(true);
                  //       // TODO: delete notification
                  //     },
                  //     icon: Icon(Icons.close, size: 20,))
                ],
              ),
            )),
      ],
    );
  }

  void _showNotificationDetailsOverlay(BuildContext context) {

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(10),
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Invitation",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Divider(),
            ],
          ),
          content: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 2, bottom: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Project Name", style: Theme.of(context).textTheme.titleMedium,),
                  const SizedBox(height: 8),
                  Text("From: emailsdashdasiuhsd.com", style: Theme.of(context).textTheme.bodyLarge,),
                  const SizedBox(height: 8),
                  Text("Role: member", style: Theme.of(context).textTheme.bodyLarge,),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                      child: Text("2024.10.12 : 12.34", style: Theme.of(context).textTheme.bodySmall,)),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: ()
              {
                // TODO: set user role according to the project referring to
                Navigator.pop(context);
                // ref
                //     .read(taskIdProvider.notifier)
                //     .state = "4ff22e99-b7";
                // context.pushNamed(
                //   RouteLocation.viewProject,
                //   pathParameters: {'??':'????'},
                // );
              },
              child: const Text('Accept'),
            ),
            TextButton(
              // TODO: REJECT the invitation
              onPressed: () => Navigator.pop(context),
              child: const Text('Reject'),
            ),

          ],
        );
      },
    );
  }
}
