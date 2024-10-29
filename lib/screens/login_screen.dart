import 'dart:convert';

import 'package:flatwork/config/config.dart';
import 'package:flatwork/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flatwork/providers/providers.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:flatwork/widgets/widgets.dart';

import '../data/models/user.dart';
import '../services/api_services.dart';

class LoginScreen extends ConsumerWidget {
  static LoginScreen builder(BuildContext context, GoRouterState state)
  => LoginScreen();
  LoginScreen({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colorScheme;
    final deviceSize = context.deviceSize;
    final authState = ref.watch(authProvider);

    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
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
                        text: 'Welcome',
                        fontSize: 60
                    ),
                    const Gap(50),
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                    ),
                    const Gap(30),
                    TextField(
                      controller: _passwordController,
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                    ),
                    const Gap(20),
                    ElevatedButton(
                      onPressed: () async {
                        final username = _emailController.text;
                        final password = _passwordController.text;
                        bool result = await _login(username,password,ref);
                        if(result)
                          {
                            context.pushNamed(RouteLocation.home);
                          }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.onPrimary,
                        minimumSize: Size(deviceSize.width, 40), // Set the minimum width and height
                      ),
                      child: const Text(
                          "login",
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
                        context.pushNamed(RouteLocation.signup);
                      },
                      child: const Text(
                        "Doesn't have an account? Sign Up",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    if (authState.isAuthenticated)
                      Text('Logged in as ${_emailController.text}'),
                  ],
                ),
              ),
            ),
          ]
        ),
      ),
    );
  }

  Future<bool> _login(String email,String password,WidgetRef ref) async {

      if(email.isEmpty || password.isEmpty){
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
        return false;
      }

      ref.read(loadingProvider.notifier).state = true;
      try{
        final response = await ApiServices().login(email, password);
        if(response != null){

          final result = response['res'];
          final Map<String, dynamic> jsonResponse = jsonDecode(result.body);
          final loggedUser = User.fromJson(jsonResponse['data']);

          final accessToken = response['access_token'];

          ref.read(loadingProvider.notifier).state = false;
          ref.read(authProvider.notifier).login(loggedUser, accessToken);
          if(_scaffoldKey.currentState != null) {
            ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
              const SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Logged Successfully!'),
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
                    Text('Invalid Username or Password!'),
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
