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
                    onTap: () async {
                      try{
                        //open overlay
                        final result = await _showNotificationDetailsOverlay(context, ref);
                        if(result == "accept")
                          {
                            ref.read(loadingProvider.notifier).state = true;
                            final result = await ApiServices().acceptInvitation(id);
                            ref.read(loadingProvider.notifier).state = false;
                            if(result)
                            {
                              ref.invalidate(userCalendarTasksProvider);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    // mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text("Invitation accepted"),
                                      SizedBox(width: 10),
                                      Icon(Icons.check_box_outlined, color: Colors.black54),
                                    ],
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              ref.read(projectIdProvider.notifier).state = projectId;
                              await AuthServices().setProjectRole(role);
                              ref.invalidate(invitationProvider);
                              context.pushNamed(
                                RouteLocation.viewProject,
                                pathParameters: {'projectId': projectId},
                              );
                            }
                            else{
                              ref.invalidate(invitationProvider);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    // mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text("Check your network connection"),
                                      SizedBox(width: 10),
                                      Icon(Icons.error_outline_rounded, color: Colors.black54),
                                    ],
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        else if(result == "reject")
                          {
                            ref.read(loadingProvider.notifier).state = true;
                            try{
                              await ApiServices().rejectInvitation(id);
                              ref.read(loadingProvider.notifier).state = false;
                              ref.invalidate(invitationProvider);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    // mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text("Invitation rejected"),
                                      SizedBox(width: 10),
                                      Icon(Icons.check_box_outlined, color: Colors.black54),
                                    ],
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                            catch(e)
                            {
                              ref.read(loadingProvider.notifier).state = false;
                              print(e.toString());
                              ref.invalidate(invitationProvider);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    // mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text("Internal server error"),
                                      SizedBox(width: 10),
                                      Icon(Icons.error_outline_rounded, color: Colors.black54),
                                    ],
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                      } catch (e)
                      {
                        ref.read(loadingProvider.notifier).state = false;
                        print(e.toString());
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              // mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("internal server error!"),
                                SizedBox(width: 10),
                                Icon(Icons.error_outline_rounded, color: Colors.black54),
                              ],
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    },
                    child: Text(
                      message.length< 30? message : "${message.substring(0,30)}...",
                      // "${message.split(' ')[0]} has invited you!",
                      style: style.titleMedium?.copyWith(
                        fontSize: 17,
                      ),
                    ),
                  ),
                  // Text("12.34", style: Theme.of(context).textTheme.bodyLarge,),
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

  Future<dynamic> _showNotificationDetailsOverlay(BuildContext context, WidgetRef ref) {
    var loading = false;

    return showDialog(
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
                  loading? Center(
                    child: CircularProgressIndicator(),
                  )
                      :
                      SizedBox.shrink(),
                ],
              ),
            ),
          ),
          actions:
          loading?
          []
          :
          [
            TextButton(
              onPressed: () async
              {
                Navigator.pop(context,"accept");

              },
              child: const Text('Accept'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context,"reject");
              },
        child: const Text('Reject'),
            ),

          ],
        );
      },
    );
  }
}
