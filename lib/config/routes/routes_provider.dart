import 'package:flatwork/config/config.dart';
import 'package:flatwork/services/api_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flatwork/providers/providers.dart';

final routesProvider = Provider<GoRouter>(
  (ref) {
    final authState = ref.watch(authProvider);
    // set the token to pi service
    if (authState.isAuthenticated) {
      ApiServices.accessToken = authState.token;
    }
    return GoRouter(
      initialLocation: authState.isAuthenticated? RouteLocation.home : RouteLocation.login,
      navigatorKey: navigationKey,
      routes: appRoutes,
    );
});