import 'package:flatwork/data/data.dart';
import 'package:flatwork/providers/api_service_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final projectIdProvider = StateProvider<String>((ref) {
  return "";
});

final projectsProvider = FutureProvider.autoDispose<List<Project>>((ref) async {
  return ref.watch(apiServiceProvider).getProjects();
});

final projectProvider = FutureProvider.autoDispose<Project>((ref) async {
  final String projectId = ref.watch(projectIdProvider);
  return ref.watch(apiServiceProvider).getProject(projectId);
});

