import 'package:flatwork/data/data.dart';
import 'package:flatwork/services/api_services.dart';
import 'package:flatwork/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateProjectScreen extends ConsumerStatefulWidget {
  static CreateProjectScreen builder(BuildContext context, GoRouterState state)
  => const CreateProjectScreen();
  const CreateProjectScreen({super.key});

  @override
  ConsumerState<CreateProjectScreen> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends ConsumerState<CreateProjectScreen> {

  final TextEditingController _projectTitleController = TextEditingController();
  final TextEditingController _projectDescriptionController = TextEditingController();

  @override
  void dispose() {
    _projectDescriptionController.dispose();
    _projectTitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const DisplayWhiteText(text: "Create new Project", fontSize: 20,),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CommonTextField(
                controller: _projectTitleController,
                title: 'Project Title',
                hintText: 'Project Title',
              ),
              const Gap(16),
              CommonTextField(
                controller: _projectDescriptionController,
                title: 'Project Description',
                hintText: 'Project Description',
                maxLines: 6,
              ),
              const Gap(60),
              ElevatedButton(
                  onPressed: () => _createProject(),
                  child: const DisplayWhiteText(
                    text: 'Save',
                    fontSize: 20,
                  )
              )
            ],
          ),
        ),
      ),
    );
  }

  void _createProject() async {
    final title = _projectTitleController.text.trim();
    final description = _projectDescriptionController.text.trim();
    if(title.isEmpty || description.isEmpty){
      //TODO: message
      print('empty title');
      return;
    }
    // final response = await ApiServices().createProject(Project(title: title, description: description));
    //
    // if(response){
    //   //TODO: message
    //       GoRouter.of(context).pop();
    // }
    // else{
    //   //TODO: message
    // }
  }
}
