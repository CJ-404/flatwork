import 'dart:ui';

import 'package:flatwork/config/config.dart';
import 'package:flatwork/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flatwork/providers/providers.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:flatwork/widgets/widgets.dart';

import '../services/api_services.dart';

class SignupScreen extends ConsumerStatefulWidget {
  static SignupScreen builder(BuildContext context, GoRouterState state) =>
      SignupScreen();

  SignupScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignupScreenState();

}


  class _SignupScreenState extends ConsumerState<SignupScreen> {

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isPasswordMatchMessage = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    // Add listener to check password match
    _confirmPasswordController.addListener(() {
      setState(() {
        _isPasswordMatchMessage = (_passwordController.text == _confirmPasswordController.text
            ? true
            : false);
      });
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final deviceSize = context.deviceSize;
    final authState = ref.watch(authProvider);

    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
              children: [
                Container(
                  height: deviceSize.height,
                  width: deviceSize.width,
                  color: colors.secondary,
                  child: Padding(
                    padding: const EdgeInsets.all(22.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const DisplayWhiteText(
                            text: 'Flatwork',
                            fontSize: 60
                        ),
                        const Gap(30),
                        TextField(
                          controller: _firstNameController,
                          decoration: const InputDecoration(labelText: 'first name'),
                        ),
                        const Gap(20),
                        TextField(
                          controller: _lastNameController,
                          decoration: const InputDecoration(labelText: 'last name'),
                        ),
                        const Gap(20),
                        TextField(
                          controller: _emailController,
                          decoration: const InputDecoration(labelText: 'Email'),
                        ),
                        const Gap(20),
                        TextField(
                          controller: _passwordController,
                          decoration: const InputDecoration(labelText: 'Password'),
                          obscureText: true,
                        ),
                        const Gap(20),
                        TextField(
                          controller: _confirmPasswordController,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            errorText: !_isPasswordMatchMessage && _confirmPasswordController.text != "" ? "password does not match" : null,
                          ),
                          obscureText: true,
                        ),
                        const Gap(20),
                        // Phone number field with country code
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Country code container with full height of TextField
                            SizedBox(
                              height: 60,  // Match height of TextField
                              child: Container(
                                width: 70,  // Adjust width as needed
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: const Text(
                                  '+94',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
        
                            // Phone number input
                            Expanded(
                              child: TextField(
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                decoration: const InputDecoration(
                                  labelText: 'Phone Number',
                                  hintText: 'Enter your number',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Gap(10),
                        ElevatedButton(
                          onPressed: () async {
                            final fname = _firstNameController.text;
                            final lname= _lastNameController.text;
                            final email = _emailController.text;
                            final password = _passwordController.text;
                            final contactNo = _phoneController.text;
                            bool result = await _signup(fname,lname,email,password,contactNo,ref);
                            if(result)
                            {
                              // user has to login again for security purposes
                              context.pushNamed(RouteLocation.login);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colors.onPrimary,
                            minimumSize: Size(deviceSize.width, 40), // Set the minimum width and height
                          ),
                          child: const Text(
                            "Register",
                            style: TextStyle(
                              fontSize: 16, // Font size
                              fontWeight: FontWeight.bold, // Font weight
                              color: Colors.black, // Text color
                              letterSpacing: 1.2, // Letter spacing
                            ),
                          ),
                        ),
                        const Gap(16),
                        GestureDetector(
                          onTap: () {
                            // Navigate to the signup page
                            context.pushNamed(RouteLocation.login);
                          },
                          child: const Text(
                            "Already have an account? Log in",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        if (authState.isAuthenticated)
                          Text('Registered as ${_emailController.text}'),
                      ],
                    ),
                  ),
                ),
              ]
          ),
        ),
      ),
    );
  }

  Future<bool> _signup(String fname, String lname, String email,String password,String contactNo, WidgetRef ref) async {

    if(fname.isEmpty || lname.isEmpty || email.isEmpty || password.isEmpty || contactNo.isEmpty ){
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
      return false;
    }

    ref.read(loadingProvider.notifier).state = true;
    try{
      final response = await ApiServices().signup(fname, lname, email, password, contactNo);
      if(response!){
        ref.read(loadingProvider.notifier).state = false;
        if(_scaffoldKey.currentState != null) {
          ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
            const SnackBar(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Signed Up Successfully!'),
                  SizedBox(width: 10),
                  Icon(Icons.check_box_outlined, color: Colors.black54),
                ],
              ),
              backgroundColor: Colors.green,
            ),
          );
        }
        // ref.refresh(authProvider);
        return true;
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
                  Text('Server error!'),
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
    return false;
  }
}
