import 'dart:ffi';

import 'package:equatable/equatable.dart';

class Project extends Equatable {
  final String? id;
  final String title;
  final String description;
  final double progress;
  // final String time;
  // final String date;
  // final bool completed;

  const Project({
    this.id,
    required this.title,
    required this.description,
    required this.progress,
    // required this.time,
    // required this.date
  });

  factory Project.fromJson(Map<String, dynamic> json){
    return Project(
      id: json['project_id'],
      title: json['project_name'],
      description: json['project_description'],
      progress: json['projectProgressStatus'],
    );
  }

  // factory Project.toJson(Map<String, dynamic> json){
  //   return Project(
  //     id: json['id'],
  //     title: json['project_name'],
  //     description: json['project_description'],
  //   );
  // }

  @override
  // TODO: implement props
  List<Object?> get props {
    return [
      id!,
      title,
      description,
      progress,
      // time,
      // date,
    ];
  }

}