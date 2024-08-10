import 'dart:convert';
import 'package:http/http.dart';
import 'package:flatwork/data/data.dart';
import 'package:shared_preferences/shared_preferences.dart';

// TODO: handle when no auth data
class AuthServices{

  Future<Map<String, String?>> getSavedUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');
    final firstName = prefs.getString('firstName');
    final lastName = prefs.getString('lastName');
    final email = prefs.getString('email');
    final role = prefs.getString('role');

    return {
      'token': token,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'role': role,
    };
  }

  Future<String> getSavedUserName() async {
    final prefs = await SharedPreferences.getInstance();
    final firstName = prefs.getString('firstName');
    final lastName = prefs.getString('lastName');

    return "${firstName!} ${lastName!}";
  }

  Future<String> getSavedUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString('role');

    return role!;
  }
}