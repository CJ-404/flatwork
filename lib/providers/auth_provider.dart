import 'package:flatwork/data/data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
      (ref) => AuthNotifier(),
);

class AuthState {
  final bool isAuthenticated;
  final String token;

  AuthState({required this.isAuthenticated, required this.token});

  factory AuthState.initial() => AuthState(isAuthenticated: false, token: '');

  AuthState copyWith({bool? isAuthenticated, String? token}) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      token: token ?? this.token,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState.initial()) {
    _loadAuthToken();
  }

  Future<void> login(User user) async {
    try {
          String token = "exmple_token_112232e45353";
          // Save token in state
          state = state.copyWith(isAuthenticated: true, token: token);

          // Persist token
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('authToken', token);
          await prefs.setString('firstName', user.firstName);
          await prefs.setString('lastName', user.lastName);
          await prefs.setString('email', user.email);
          await prefs.setString('role', user.role!);
    } catch (e) {
      print(e);
    }
  }

  Future<void> logout() async {
    // Clear token in state
    state = state.copyWith(isAuthenticated: false, token: '');

    // Remove token from shared preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');
    await prefs.remove('firstName');
    await prefs.remove('lastName');
    await prefs.remove('email');
    await prefs.remove('role');
  }

  Future<void> _loadAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    if (token != null) {
      state = state.copyWith(isAuthenticated: true, token: token);
    }
  }
}
