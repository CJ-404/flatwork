import 'package:flatwork/data/data.dart';
import 'package:flatwork/providers/providers.dart';
import 'package:flatwork/services/api_services.dart';
import 'package:flatwork/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../config/routes/route_location.dart';
import '../providers/project/projects_provider.dart';
import '../services/auth_services.dart';

class NotificationTile extends ConsumerWidget {
  const NotificationTile({super.key, required this.message, this.onClose, required this.projectId, required this.id, required this.role});

  final String message;
  final String projectId;
  final String id;
  final String role;
  final Function(bool?)? onClose;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                      _showNotificationDetailsOverlay(context, ref);
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

  void _showNotificationDetailsOverlay(BuildContext context, WidgetRef ref) {

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
                  Text(message, style: Theme.of(context).textTheme.titleMedium,),
                  const SizedBox(height: 8),
                  // Text("From: emailsdashdasiuhsd.com", style: Theme.of(context).textTheme.bodyLarge,),
                  // const SizedBox(height: 8),
                  Text("Role: $role", style: Theme.of(context).textTheme.bodyLarge,),
                  // const SizedBox(height: 8),
                  // Align(
                  //   alignment: Alignment.centerRight,
                  //     child: Text("2024.10.12 : 12.34", style: Theme.of(context).textTheme.bodySmall,)),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async
              {
                // TODO: set user role according to the project referring to
                Navigator.pop(context);
                ref.read(projectIdProvider.notifier).state = projectId;
                await AuthServices().setProjectRole(role);
                ref.invalidate(invitationProvider);
                context.pushNamed(
                  RouteLocation.viewProject,
                  pathParameters: {'projectId': projectId},
                );
              },
              child: const Text('Accept'),
            ),
            TextButton(
              // TODO: REJECT the invitation
              onPressed: () async {
                await ApiServices().rejectInvitation(id);
                ref.invalidate(invitationProvider);
                Navigator.pop(context);
              },
        child: const Text('Reject'),
            ),

          ],
        );
      },
    );
  }
}
