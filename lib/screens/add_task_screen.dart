import 'package:flatwork/utils/extensions.dart';
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

  @override
  void dispose() {
    _taskDescriptionController.dispose();
    _taskTitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.colorScheme.secondary,
        title: const DisplayWhiteText(text: "Add new Task", fontSize: 20,),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
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
                  onPressed: (){
                    //TODO: send data to the backend
                  },
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

  void createtask() async{
    final title = _taskTitleController.text.trim();
    final description = _taskDescriptionController.text.trim();
    if(title.isEmpty || description.isEmpty){
      //TODO: message
      print('empty title');
      return;
    }
    // final response = await ApiServices().addTask(
    //     Task(
    //         title: title,
    //         description: description,
    //         assignedTeamMembers: const [],
    //         isCompleted: false,
    //     ),
    //     widget.projectId
    // );
    //
    // if(response){
    //   //TODO: message
    //    GoRouter.of(context).pop();
    // }
    // else{
    //   //TODO: message
    // }
  }
}
