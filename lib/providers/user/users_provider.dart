import 'package:flatwork/data/data.dart';
import 'package:flatwork/providers/api_service_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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