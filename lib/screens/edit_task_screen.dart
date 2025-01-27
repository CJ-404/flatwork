import 'package:file_picker/file_picker.dart';
import 'package:flatwork/data/data.dart';
import 'package:flatwork/services/auth_services.dart';
import 'package:flatwork/utils/utils.dart';
import 'package:flatwork/widgets/progress_bar_with_labels.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import '../services/api_services.dart';
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
    final progressValue = ref.watch(taskProgressProvider);
    final colors = context.colorScheme;

    return fetchedTask.when(
      data: (fetchedTask){
        Task task = fetchedTask;
        return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            backgroundColor: Colors.cyan,
            title: Row(
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
                    Text(
                            task.description,
                            style: context.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                    const Gap(30),
                    Text(
                      "Progress",
                      style: context.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                    const Divider(
                      thickness: 1,
                      color: Colors.black,
                    ),
                    Text(
                      "Make sure to update your task progress so that project managers can view task status",
                      style: context.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                    const Gap(20),
                    Center(
                      child: Text(
                        "$progressValue%",
                        style: context.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    ProgressBarWithLabels(taskId:taskId),
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
                    SingleChildScrollView(
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
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      error: (error,s) => Text(error.toString()),
      loading: () =>  const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void _getPermissionOverlay(BuildContext context, WidgetRef ref, FilePickerResult pickedFile) async {
    final userRole = await AuthServices().getSavedUserRole();
    final colors = context.colorScheme;
    final selectedFile = pickedFile.files.first;
    showDialog(
      context: context,
      barrierDismissible: false, // dismiss when tapping outside
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
                const Text(
                  'upload',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                const Divider(thickness: 1.5,),
                Text(
                  'Are you sure you want to upload ${selectedFile.name}?',
                  style: const TextStyle(fontSize: 16.0,),
                ),
                const Gap(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        try{
                          // upload file to the firebase
                          final uploadedUrl = await FileManager().uploadFile(pickedFile, 'shared_files/task/');
                          print('upload Url : $uploadedUrl');

                          // send link to the backend
                          // if not created, exception will pop
                          final created = await ApiServices().createTaskFile(taskId, pickedFile.files.first.name, uploadedUrl);
                          // TODO: refresh getting shared files ref
                          // for now just pop from context to load again by taping
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                // mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("file uploaded!"),
                                  SizedBox(width: 10),
                                  Icon(Icons.check_box_outlined, color: Colors.black54),
                                ],
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                        catch (e){
                          print('error: $e');
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                // mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("file not uploaded! error occurred"),
                                  SizedBox(width: 10),
                                  Icon( Icons.error_outline_rounded , color: Colors.black54),
                                ],
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: const Text('Upload'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // remove selected file
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showOverlayDialog(BuildContext context, WidgetRef ref) async {
    final userRole = await AuthServices().getSavedUserRole();
    try{
      final files = await ApiServices().getTaskFiles(taskId);
      final fileLinks = files.map((file) => file.url).toList();
      // print(fileLinks);

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
                        onPressed: () async {
                          FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: ['pdf','pptx','doc','docx'], // TODO: add more required types
                          );
                          if (pickedFile == null) return;
                          // File file = File(pickedFile.files.single.path!);
                          // final selectedFile = pickedFile.files.first;
                          Navigator.of(context).pop();
                          _getPermissionOverlay(context, ref, pickedFile);
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
                        DisplayListOfSharedFiles(
                            sharedFileLinks:
                            fileLinks,
                            ref: ref
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
    catch (e)
    {
      print(e);
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // mainAxisSize: MainAxisSize.min,
            children: [
              Text("Check your connection!"),
              SizedBox(width: 10),
              Icon( Icons.error_outline_rounded , color: Colors.black54),
            ],
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
  }
}
