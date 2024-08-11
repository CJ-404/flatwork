import 'package:flatwork/data/data.dart';
import 'package:flatwork/providers/loading_provider.dart';
import 'package:flatwork/providers/project/project.dart';
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
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    _projectDescriptionController.dispose();
    _projectTitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loading = ref.watch(loadingProvider);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const DisplayWhiteText(text: "Create new Project", fontSize: 20,),
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
                      onPressed: () => _createProject(ref),
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

  void _createProject(WidgetRef ref) async {
    final title = _projectTitleController.text.trim();
    final description = _projectDescriptionController.text.trim();
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
      final response = await ApiServices().createProject(Project(title: title, description: description, progress: 0.0));
      if(response){
        ref.read(loadingProvider.notifier).state = false;
        if(_scaffoldKey.currentState != null) {
          ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
            const SnackBar(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Created new project!'),
                  SizedBox(width: 10),
                  Icon(Icons.check_box_outlined, color: Colors.black54),
                ],
              ),
              backgroundColor: Colors.green,
            ),
          );
        }
        ref.refresh(projectsProvider);
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
