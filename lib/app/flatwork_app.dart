import 'package:flatwork/config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FlatWorkApp extends ConsumerWidget {
  const FlatWorkApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routerConfig = ref.watch(routesProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      // title: 'Flutter Demo',
      theme: AppTheme.light,
      routerConfig: routerConfig,
    );
  }
}