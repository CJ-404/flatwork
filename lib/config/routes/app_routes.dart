import 'package:flatwork/config/config.dart';
import 'package:flatwork/screens/login_screen.dart';
import 'package:flatwork/screens/project_screen.dart';
import 'package:flatwork/screens/screens.dart';
import 'package:flatwork/screens/settings_screen.dart';
import 'package:flatwork/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


final navigationKey = GlobalKey<NavigatorState>();

final appRoutes = [
  GoRoute(
    path: RouteLocation.login,
    name: RouteLocation.login,
    parentNavigatorKey:navigationKey,
    builder: LoginScreen.builder,
  ),
  GoRoute(
    path: RouteLocation.signup,
    name: RouteLocation.signup,
    parentNavigatorKey:navigationKey,
    builder: SignupScreen.builder,
  ),
  GoRoute(
    path: RouteLocation.home,
    name: RouteLocation.home,
    parentNavigatorKey:navigationKey,
    builder: HomeScreen.builder,
  ),
  GoRoute(
    path: RouteLocation.projects,
    name: RouteLocation.projects,
    parentNavigatorKey:navigationKey,
    builder: ProjectScreen.builder,
  ),
  GoRoute(
    path: RouteLocation.settings,
    name: RouteLocation.settings,
    parentNavigatorKey:navigationKey,
    builder: SettingsScreen.builder,
  ),
  GoRoute(
    path: RouteLocation.createProject,
    name: RouteLocation.createProject,
    parentNavigatorKey:navigationKey,
    builder: CreateProjectScreen.builder,
  ),
  GoRoute(
    path: RouteLocation.viewProject,
    name: RouteLocation.viewProject,
    parentNavigatorKey:navigationKey,
    builder: (context, state) => ViewProjectScreen.builder(
        context, state, state.pathParameters['projectId'] as String),
  ),
  GoRoute(
    path: RouteLocation.editTask,
    name: RouteLocation.editTask,
    parentNavigatorKey:navigationKey,
    builder: (context, state) => EditTaskScreen.builder(
        context, state, state.pathParameters['taskId'] as String),
  ),
  GoRoute(
    path: RouteLocation.addTask,
    name: RouteLocation.addTask,
    parentNavigatorKey:navigationKey,
    builder: (context, state) => AddTaskScreen.builder(
        context, state, state.pathParameters['projectId'] as String),
  ),
];