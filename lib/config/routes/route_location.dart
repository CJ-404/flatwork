import 'package:flutter/material.dart';

@immutable
class RouteLocation{
  const RouteLocation._();

  static String get login => '/login';
  static String get home => '/home';
  static String get createProject => '/createProject';
  static String get viewProject => '/viewProject/:projectId';
  static String get editTask => '/editTask/:taskId';
  static String get addTask => '/addTask/:projectId';
}