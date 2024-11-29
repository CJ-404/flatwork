import 'package:file_picker/file_picker.dart';
import 'package:flatwork/data/data.dart';
import 'package:flatwork/providers/loading_provider.dart';
import 'package:flatwork/providers/project/project.dart';
import 'package:flatwork/providers/providers.dart';
import 'package:flatwork/services/api_services.dart';
import 'package:flatwork/widgets/main_scaffold.dart';
import 'package:flatwork/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flatwork/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditPassword extends ConsumerStatefulWidget {

  static EditPassword builder(BuildContext context, GoRouterState state)
  => const EditPassword();
  const EditPassword({super.key});

  @override
  ConsumerState<EditPassword> createState() => _EditPasswordState();
}

class _EditPasswordState extends ConsumerState<EditPassword> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userData = ref.read(userDataProvider);
    final loading = ref.read(loadingProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Password'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: loading?
          Center(
            child: CircularProgressIndicator(),
          )
          :
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                TextFormField(
                  controller: _oldPasswordController,
                  decoration: const InputDecoration(
                    labelText: 'Old Password',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.visibility),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your old password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _newPasswordController,
                  decoration: const InputDecoration(
                    labelText: 'New Password',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.visibility),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your new password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      ref.read(loadingProvider.notifier).state = true;
                      if (_formKey.currentState!.validate()) {
                        // Handle form submission
                        try{
                          final result = await ApiServices().updatePassword(
                              userData.value!["userId"]!,
                              _oldPasswordController.text,
                              _newPasswordController.text
                          );
                          ref.read(loadingProvider.notifier).state = false;
                          if(result)
                            {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    // mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('Password changed successfully'),
                                      SizedBox(width: 10),
                                      Icon(Icons.check_box_outlined, color: Colors.black54),
                                    ],
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              context.pop(context);
                            }
                          else{
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  // mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('Old Password is incorrect'),
                                    SizedBox(width: 10),
                                    Icon(Icons.error_outline_rounded, color: Colors.black54),
                                  ],
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                        catch(e)
                      {
                        ref.read(loadingProvider.notifier).state = false;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              // mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Internal Server Error!'),
                                SizedBox(width: 10),
                                Icon(Icons.error_outline_rounded, color: Colors.black54),
                              ],
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                        print(e.toString());
                      }
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
                      child: Text(
                          'Save',
                          style: context.textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
