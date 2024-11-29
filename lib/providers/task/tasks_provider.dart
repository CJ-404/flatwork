import 'package:flatwork/data/data.dart';
import 'package:flatwork/providers/api_service_provider.dart';
import 'package:flatwork/services/auth_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/calendarTask.dart';
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

final userCalendarTasksProvider = FutureProvider.autoDispose<List<CalendarTask>>((ref) async {
  final String userId = await AuthServices().getSavedUserId();
  return ref.watch(apiServiceProvider).getAllTasksByUserId(userId);
});