import 'package:equatable/equatable.dart';
import 'package:flatwork/data/models/user.dart';

class Task extends Equatable {
  final int? id;
  final String title;
  final String description;
  final List<User> assignedTeamMembers;
  final bool isCompleted;
  // final String time;
  // final String date;

  const Task({
    this.id,
    required this.title,
    required this.description,
    required this.assignedTeamMembers,
    required this.isCompleted,
    // required this.time,
    // required this.date
  });

  factory Task.fromJson(Map<String, dynamic> json){
    return Task(
      id: json['id'],
      title: json['task_name'],
      description: json['task_description'],
      assignedTeamMembers: json['teamMembers'],
      isCompleted: false,
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
      isCompleted,
      // time,
      // date,
    ];
  }

}