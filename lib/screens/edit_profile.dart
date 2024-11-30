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

class EditProfile extends ConsumerStatefulWidget {

  static EditProfile builder(BuildContext context, GoRouterState state)
  => const EditProfile();
  const EditProfile({super.key});

  @override
  ConsumerState<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends ConsumerState<EditProfile> {

  // final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  // final TextEditingController _emailController = TextEditingController();
  late TextEditingController _mobileController;
  late TextEditingController _fnameController;
  late TextEditingController _lnameController;
  // final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final userData = ref.read(userDataProvider);
    print("${userData.value}");
    _fnameController = TextEditingController(text: userData.value?["firstName"]);
    _lnameController = TextEditingController(text: userData.value?["lastName"]);
    _mobileController = TextEditingController(text: "${userData.value?["contact"]}");
  }

  @override
  void dispose() {
    // _emailController.dispose();
    _mobileController.dispose();
    _fnameController.dispose();
    _lnameController.dispose();
    // _passwordController.dispose();
    super.dispose();
  }


  // final loading = ref.watch(loadingProvider);
  // final colors = context.colorScheme;
  // final deviceSize = context.deviceSize;

  @override
  Widget build(BuildContext context) {
    final userData = ref.read(userDataProvider);
    final loading = ref.read(loadingProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
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
                // Center(
                //   child: Stack(
                //     children: [
                //       CircleAvatar(
                //         radius: 50,
                //         backgroundImage: AssetImage('images/default_profile.webp'),
                //         // Replace with user's profile image, if available
                //       ),
                //       Positioned(
                //         bottom: 0,
                //         right: 0,
                //         child: GestureDetector(
                //           onTap: () async {
                //             FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
                //               type: FileType.custom,
                //               allowedExtensions: ['jpg','jpeg','png'],
                //             );
                //             // if (pickedFile == null) return;
                //             // File file = File(result.files.single.path!);
                //             // final selectedFile = result.files.first;
                //             // _getPermissionOverlay(context, ref, pickedFile);
                //           },
                //           child: CircleAvatar(
                //             radius: 15,
                //             backgroundColor: Colors.blue,
                //             child: Icon(
                //               Icons.camera_alt,
                //               color: Colors.white,
                //               size: 18,
                //             ),
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                const SizedBox(height: 20),
                TextFormField(
                  // initialValue: userData.value?['firstName']?? "",
                  controller: _fnameController,
                  decoration: const InputDecoration(
                    labelText: 'First Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  // initialValue: userData.value?['lastName']?? "",
                  controller: _lnameController,
                  decoration: const InputDecoration(
                    labelText: 'Last Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your last name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  // initialValue: userData.value?['contact']?? "",
                  controller: _mobileController,
                  decoration: const InputDecoration(
                    labelText: 'Mobile Number',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your mobile number';
                    }
                    if (!RegExp(r'^\d{10,}$').hasMatch(value)) {
                      return 'Please enter a valid mobile number';
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
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setString('firstName', _fnameController.text);
                          await prefs.setString('lastName', _lnameController.text);
                          await prefs.setString('contact', _mobileController.text);
                          final result = await ApiServices().updateUser(
                              userData.value!["userId"]!,
                              _fnameController.text,
                              _lnameController.text,
                              _mobileController.text
                          );
                          ref.read(loadingProvider.notifier).state = false;
                          if(result)
                            {
                              ref.invalidate(userDataProvider);
                              ref.refresh(userDataProvider);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    // mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('Profile updated successfully'),
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
                                    Text('Check your changes again'),
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
