import 'package:flatwork/data/data.dart';
import 'package:flatwork/providers/api_service_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../project/projects_provider.dart';

final taskIdProvider = StateProvider<String>((ref) {
  return "";
});

final taskProgressProvider = StateProvider<double>((ref) {
  return 0.0;
});

final tasksProvider = FutureProvider.autoDispose<List<Task>>((ref) async {
  final String projectId = ref.watch(projectIdProvider);
  return ref.watch(apiServiceProvider).getTasks(projectId);
});

final taskProvider = FutureProvider.autoDispose<Task>((ref) async {
  final String taskId = ref.watch(taskIdProvider);
  return ref.watch(apiServiceProvider).getTask(taskId);
});