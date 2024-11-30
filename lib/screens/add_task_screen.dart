import 'package:flatwork/providers/providers.dart';
import 'package:flatwork/utils/extensions.dart';
import 'package:flatwork/widgets/main_scaffold.dart';
import 'package:flatwork/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
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
  DateTime? _selectedDate;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    _taskDescriptionController.dispose();
    _taskTitleController.dispose();
    super.dispose();
  }

  void _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
        String formattedDate = '${_selectedDate?.toIso8601String().replaceFirst(RegExp(r'\.\d+'), '')}Z';
        print(formattedDate);
      }
    }
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
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _pickDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _selectedDate != null
                        ? DateFormat('yyyy-MM-dd HH:mm').format(_selectedDate!)
                        : 'Select Date and Time',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
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
                Text('All fields should be filled!'),
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
            endDate: '${_selectedDate?.toIso8601String().replaceFirst(RegExp(r'\.\d+'), '')}Z',
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
                  errorMessage?? "Internal server error",
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
