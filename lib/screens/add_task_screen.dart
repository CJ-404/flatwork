import 'package:flatwork/providers/providers.dart';
import 'package:flatwork/utils/extensions.dart';
import 'package:flatwork/widgets/main_scaffold.dart';
import 'package:flatwork/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/data.dart';
import '../services/api_services.dart';

class AddTaskScreen extends ConsumerStatefulWidget {
  static AddTaskScreen builder(BuildContext context, GoRouterState state,String projectId)
  => AddTaskScreen(projectId: projectId,);
  const AddTaskScreen({super.key, required this.projectId});

  final String projectId;

  @override
  ConsumerState<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends ConsumerState<AddTaskScreen> {
  final TextEditingController _taskTitleController = TextEditingController();
  final TextEditingController _taskDescriptionController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    _taskDescriptionController.dispose();
    _taskTitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loading = ref.watch(loadingProvider);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: context.colorScheme.secondary,
        title: const DisplayWhiteText(text: "Add new Task", fontSize: 20,),
      ),
      body: SafeArea(
        child: loading?
        const Center(
          child: CircularProgressIndicator(),
        )
            :
        SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CommonTextField(
                controller: _taskTitleController,
                title: 'Task Title',
                hintText: 'Task Title',
              ),
              const Gap(16),
              CommonTextField(
                controller: _taskDescriptionController,
                title: 'Task Description',
                hintText: 'Task Description',
                maxLines: 6,
              ),
              const Gap(60),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.colorScheme.secondary,
                  ),
                  onPressed: ()=> _createTask(ref),
                  child: const DisplayWhiteText(
                    text: 'Add',
                    fontSize: 20,
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _createTask(WidgetRef ref) async{
    final title = _taskTitleController.text.trim();
    final description = _taskDescriptionController.text.trim();
    if(title.isEmpty || description.isEmpty){
      if(_scaffoldKey.currentState != null) {
        ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
          const SnackBar(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // mainAxisSize: MainAxisSize.min,
              children: [
                Text('Both fields should be filled!'),
                SizedBox(width: 10),
                Icon(Icons.error_outline_rounded, color: Colors.black54),
              ],
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    ref.read(loadingProvider.notifier).state = true;
    try{
      final response = await ApiServices().addTask(
          Task(
            title: title,
            description: description,
            // assignedTeamMembers: const [],
            isCompleted: false,
          ),
          widget.projectId
      );
      if(response){
        ref.read(loadingProvider.notifier).state = false;
        if(_scaffoldKey.currentState != null) {
          ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
            const SnackBar(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Created new task!'),
                  SizedBox(width: 10),
                  Icon(Icons.check_box_outlined, color: Colors.black54),
                ],
              ),
              backgroundColor: Colors.green,
            ),
          );
        }
        ref.refresh(tasksProvider);
        GoRouter.of(_scaffoldKey.currentContext!).pop();
      }
      else{
        ref.read(loadingProvider.notifier).state = false;
        if(_scaffoldKey.currentState != null) {
          ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
            const SnackBar(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Check your Network Connection and Try Again'),
                  SizedBox(width: 10),
                  Icon(Icons.error_outline_rounded, color: Colors.black54),
                ],
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
    catch (e){
      // print(e.toString());
      ref.read(loadingProvider.notifier).state = false;
      final errorMessage = e.toString();
      if(_scaffoldKey.currentState != null) {
        ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
          SnackBar(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  errorMessage,
                  style: const TextStyle(
                      fontSize: 8
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(Icons.error_outline_rounded, color: Colors.black54),
              ],
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
