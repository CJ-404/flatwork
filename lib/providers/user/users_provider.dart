import 'package:flatwork/data/data.dart';
import 'package:flatwork/data/models/invitation.dart';
import 'package:flatwork/providers/api_service_provider.dart';
import 'package:flatwork/services/api_services.dart';
import 'package:flatwork/services/auth_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../project/projects_provider.dart';

final AllUserListProvider = StateNotifierProvider.autoDispose<AllUserListNotifier, List<User>>(
      (ref) => AllUserListNotifier(ref),
);

class AllUserListNotifier extends StateNotifier<List<User>> {
  List<User> _allUsers = [];

  AllUserListNotifier(AutoDisposeStateNotifierProviderRef ref) : super([]) {
    // Initialize the state
    getUsers() async {
      _allUsers = await ApiServices().getAllUsers();
      state = _allUsers;
    }
    getUsers();
  }

  void filterAllUsers(String query) {
    if (query.isEmpty) {
      // If query is empty, reset to the empty set
      state = [];
    } else {
      // Filter the list based on the query
      state = _allUsers
          .where((user) => user.email.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }
}

final projectUserListProvider = StateNotifierProvider.autoDispose<ProjectUserListNotifier, List<User>>(
      (ref) => ProjectUserListNotifier(ref),
);

class ProjectUserListNotifier extends StateNotifier<List<User>> {
  List<User> _allProjectUsers = [];

  ProjectUserListNotifier(AutoDisposeStateNotifierProviderRef ref) : super([]) {
    // Initialize the state
    // state = _allProjectUsers;
    final String projectId = ref.watch(projectIdProvider);
    getUsers() async {
      _allProjectUsers = await ApiServices().getProjectUsers(projectId);
      state = _allProjectUsers;
    }
    getUsers();
  }

  void filterProjectUsers(String query) {
    if (query.isEmpty) {
      // If query is empty, reset to the empty set
      state = _allProjectUsers;
    } else {
      // Filter the list based on the query
      state = _allProjectUsers
          .where((user) => user.email.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }
}


final userFilterProvider = StateProvider<String>((ref) {
  return "";
});

final usersProvider = FutureProvider.autoDispose<List<User>>((ref) async {
  final String projectId = ref.watch(projectIdProvider);
  return ref.watch(apiServiceProvider).getProjectUsers(projectId);
});

// final assignedUsersProvider = FutureProvider<List<User>>((ref) async {
//   final String taskId = ref.watch(taskIdProvider);
//   return ref.watch(apiServiceProvider).getAssignedUsers(taskId);
// });

final invitationProvider = FutureProvider.autoDispose<List<Invitation>>((ref) async {
  final String userId = await  AuthServices().getSavedUserId();
  return ref.watch(apiServiceProvider).getInvitations(userId);
});

final authServicesProvider = Provider<AuthServices>((ref) {
  return AuthServices(); // Your existing AuthService class
});

final userDataProvider = FutureProvider<Map<String, String?>>((ref) async {
  final authService = ref.read(authServicesProvider);
  return await authService.getSavedUserData();
});