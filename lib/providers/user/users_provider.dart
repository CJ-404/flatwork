import 'package:flatwork/data/data.dart';
import 'package:flatwork/providers/api_service_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final AllUserListProvider = StateNotifierProvider.autoDispose<AllUserListNotifier, List<Map<String, String>>>(
      (ref) => AllUserListNotifier(),
);

class AllUserListNotifier extends StateNotifier<List<Map<String, String>>> {
  final List<Map<String, String>> _allProjectUsers = [
    {'userId': '111', 'name': 'Alice', 'email': 'qwe'},
    {'userId': '2', 'name': 'Bob', 'email': 'wer'},
    {'userId': '3', 'name': 'Charlie', 'email': 'ert'},
    {'userId': '4', 'name': 'David', 'email': 'sdf'},
    {'userId': '5', 'name': 'Eve', 'email': 'tyu'},
  ];

  AllUserListNotifier() : super([]) {
    // Initialize the state
    state = _allProjectUsers;
    //TODO: add the async function after backend is implemented
  }

  void filterAllUsers(String query) {
    if (query.isEmpty) {
      // If query is empty, reset to the empty set
      state = [];
    } else {
      // Filter the list based on the query
      state = _allProjectUsers
          .where((user) => user['email']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }
}

final projectUserListProvider = StateNotifierProvider.autoDispose<ProjectUserListNotifier, List<Map<String, String>>>(
      (ref) => ProjectUserListNotifier(),
);

class ProjectUserListNotifier extends StateNotifier<List<Map<String, String>>> {
  final List<Map<String, String>> _allProjectUsers = [
    {'userId': '111', 'name': 'AAlice', 'email': 'qwe'},
    {'userId': '2', 'name': 'BBob', 'email': 'wer'},
    {'userId': '3', 'name': 'CCharlie', 'email': 'ert'},
    {'userId': '4', 'name': 'DDavid', 'email': 'sdf'},
    {'userId': '5', 'name': 'EEve', 'email': 'tyu'},
  ];

  ProjectUserListNotifier() : super([]) {
    // Initialize the state
    state = _allProjectUsers;
    //TODO: add the async function after backend is implemented
  }

  void filterProjectUsers(String query) {
    if (query.isEmpty) {
      // If query is empty, reset to the empty set
      state = _allProjectUsers;
    } else {
      // Filter the list based on the query
      state = _allProjectUsers
          .where((user) => user['email']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }
}


final userFilterProvider = StateProvider<String>((ref) {
  return "";
});

final usersProvider = FutureProvider.autoDispose<List<User>>((ref) async {
  return ref.watch(apiServiceProvider).getUsers();
});

// final assignedUsersProvider = FutureProvider<List<User>>((ref) async {
//   final String taskId = ref.watch(taskIdProvider);
//   return ref.watch(apiServiceProvider).getAssignedUsers(taskId);
// });