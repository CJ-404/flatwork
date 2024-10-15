import 'package:flutter/material.dart';

@immutable
class RouteLocation{
  const RouteLocation._();

  static String get login => '/login';
  static String get signup => '/signup';
  static String get home => '/home';
  static String get projects => '/projects';
  static String get settings => '/settings';
  static String get createProject => '/createProject';
  static String get viewProject => '/viewProject/:projectId';
  static String get editTask => '/editTask/:taskId';
  static String get addTask => '/addTask/:projectId';
}