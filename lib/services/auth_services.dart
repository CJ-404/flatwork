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
    final userId = prefs.getString('userId');
    final contact = prefs.getString('contact');
    return {
      'token': token,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'role': role,
      'userId': userId,
      'contact': contact,
    };
  }

  Future<void> setProjectRole(String newRole) async {
    try {

      // Persist token
      print("set new role=$newRole");
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('role', newRole);
    } catch (e) {
      print(e);
    }
  }

  Future<String> getSavedUserName() async {
    final prefs = await SharedPreferences.getInstance();
    final firstName = prefs.getString('firstName');
    final lastName = prefs.getString('lastName');

    return "${firstName!} ${lastName!}";
  }

  Future<String> getSavedUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    return userId!;
  }

  Future<String> getSavedUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString('role');

    return role!;
  }
}