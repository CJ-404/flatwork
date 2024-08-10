import 'package:flatwork/data/data.dart';
import 'package:flatwork/services/auth_services.dart';
import 'package:flatwork/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import '../widgets/display_list_of_shared_files.dart';
import '../widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flatwork/providers/providers.dart';

class EditTaskScreen extends ConsumerWidget {
  static EditTaskScreen builder(BuildContext context, GoRouterState state, String taskId)
  => EditTaskScreen(taskId: taskId);
  const EditTaskScreen({super.key, required this.taskId});

  final String taskId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final taskIdState = ref.watch(taskIdProvider);
    final scaffoldKey = GlobalKey<ScaffoldState>();
    final fetchedTask = ref.watch(taskProvider);
    final colors = context.colorScheme;

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: fetchedTask.when(
          data: (fetchedTask){
            Task task = fetchedTask;
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DisplayWhiteText(text: task.title, fontSize: 20,),
                IconButton(
                  icon: Icon(Icons.edit_document, color: colors.onPrimary,size: 30,),
                  onPressed: () {
                    showOverlayDialog(context, ref);
                  },
                ),
              ],
            );
          },
          error: (error,s) => Text(error.toString()),
          loading: () =>  const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20.0),
          child: Padding(
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
                  "Task description",
                  style: context.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                const Divider(
                  thickness: 1,
                  color: Colors.black,
                ),
                fetchedTask.when(
                    data: (fetchedTask){
                      Task task = fetchedTask;

                      return Text(
                        task.description,
                        style: context.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      );
                    },
                    error: (error, s)=> Text(error.toString()),
                    loading: ()=> const Center(
                      child: CircularProgressIndicator(),
                    )
                ),
                const Gap(30),
                Text(
                  "Assigned User",
                  style: context.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                const Divider(
                  thickness: 1,
                  color: Colors.black,
                ),
                fetchedTask.when(
                    data: (fetchedTask){
                      //TODO: get the team members
                      Task task = fetchedTask;

                      return SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            DisplayListOfUsers(
                              assignedUsers: task.assignedUser == null? [] : [task.assignedUser!],
                              scaffoldKey: scaffoldKey,
                            ),
                            const Gap(20),
                            FutureBuilder<String>(
                              future: AuthServices().getSavedUserRole(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Center(child: Text('Error: ${snapshot.error}'));
                                // } else if (!snapshot.hasData || snapshot.data!['token'] == null) {
                                //   return Center(child: Text('User data not found.'));
                                } else {
                                  final userRole = snapshot.data!;
                                  return (userRole == "manager")?
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.cyan,
                                        ),
                                        onPressed: () async {
                                          ref.read(userFilterProvider.notifier).state = "";
                                          await showModalBottomSheet(
                                            // showDragHandle: true,
                                            context: context,
                                            builder: (ctx) {
                                              return SelectTeamMember(assignedMembers: task.assignedUser==null? []:[task.assignedUser!],scaffoldKey: scaffoldKey,);
                                            },
                                          );
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: DisplayWhiteText(
                                            text:'Assign a team member',
                                            fontSize: 20,
                                          ),
                                        )
                                    )
                                  : Container();
                                }
                              },
                            ),
                          ],
                        ),
                      );
                    },
                    error: (error, s)=> Text(error.toString()),
                    loading: ()=> const Center(
                      child: CircularProgressIndicator(),
                    )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showOverlayDialog(BuildContext context, WidgetRef ref) async {
    final userRole = await AuthServices().getSavedUserRole();
    final colors = context.colorScheme;
    showDialog(
      context: context,
      barrierDismissible: true, // dismiss when tapping outside
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          elevation: 16,
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                (userRole == "manager")?
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Shared task files',
                        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: Icon(Icons.add, color: colors.primary,size: 30,),
                        onPressed: () {
                        },
                      ),
                    ],
                  )
                :
                  const Text(
                    'Shared task files',
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                const Divider(thickness: 1.5,),
                //list of shared files
                SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      DisplayListOfSharedFiles(sharedFiles: const ["asa1","fathead1"], ref: ref),
                    ],
                  ),
                ),
                // ElevatedButton(
                //   onPressed: () {
                //     Navigator.of(context).pop(); // Close the dialog
                //   },
                //   child: const Text('Close'),
                // ),
              ],
            ),
          ),
        );
      },
    );
  }
}
