import 'package:flatwork/config/config.dart';
import 'package:flatwork/services/api_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flatwork/providers/providers.dart';
import '../../widgets/main_scaffold.dart';

final routesProvider = Provider<GoRouter>(
  (ref) {
    final authState = ref.watch(authProvider);
    String location = RouteLocation.login;

    // reset bottom navigation index state
    ref.read(bottomNavigationIndexProvider.notifier).state = 0;

    if (authState.isAuthenticated) {
      // set the token ato pi service
      ApiServices.accessToken = authState.token;
      location = RouteLocation.home;
    }
    return GoRouter(
      initialLocation: location,
      navigatorKey: navigationKey,
      routes: appRoutes,
    );
});