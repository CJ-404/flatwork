import 'package:equatable/equatable.dart';
import 'package:flatwork/data/models/user.dart';

class Task extends Equatable {
  final String? id;
  final String title;
  final String description;
  final User? assignedUser;
  // final List<User> assignedTeamMembers;
  final bool isCompleted;
  final double? progress;
  // final String time;
  final String? endDate;

  const Task({
    this.id,
    required this.title,
    required this.description,
    // required this.assignedTeamMembers,
    this.assignedUser,
    required this.isCompleted,
    this.progress,
    this.endDate,

    // required this.time,
    // required this.date
  });

  factory Task.fromJson(Map<String, dynamic> json){
    // print(json['name'] == "null null");
    // print(json['user_Id'] == null);
    User? assigned = (json['name'] == null || json['user_Id'] == null)?
    null
        :
    User(id: json['user_Id'] ,firstName: json['name'], lastName: "", email: "", contact: "");

    return Task(
      id: json['task_Id'],
      title: json['task_Name'],
      description: json['task_Description'],
      assignedUser: assigned,
      // assignedTeamMembers: const [],//json['teamMembers'],
      isCompleted: false,
      progress: json['progressStatus'],
      endDate: json['deadlineDate'] ?? '${DateTime.now().toUtc().add(const Duration(days: 14)).toIso8601String().replaceFirst(RegExp(r'\.\d+'), '')}Z',
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
      assignedUser,
      // assignedTeamMembers,
      isCompleted,
      progress!,
      endDate!,
      // time,
      // date,
    ];
  }

}