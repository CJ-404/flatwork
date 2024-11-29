import 'package:equatable/equatable.dart';

class CalendarTask extends Equatable {
  final DateTime deadline;
  final double progress;
  final String userRole;
  final String name;
  final String taskDescription;
  final DateTime taskCreatedDate;
  final String projectName;
  final String userId;
  final String taskId;
  final String taskName;
  final String projectId;

  const CalendarTask( {
      required this.deadline,
      required this.progress,
      required this.userRole,
      required this.name,
      required this.taskDescription,
      required this.taskCreatedDate,
      required this.projectName,
      required this.userId,
      required this.taskId,
      required this.taskName,
      required this.projectId,
  });

  factory CalendarTask.fromJson(Map<String, dynamic> json){
    return CalendarTask(
         deadline : DateTime.parse(json['deadlineDate']),
         progress : json['progressStatus'],
         userRole : json['userRole'],
         name : json['name'],
         taskDescription : json['task_Description'],
         taskCreatedDate : DateTime.parse(json['task_created_Date']),
         projectName : json['project_Name'],
         userId : json['user_Id'],
         taskId : json['task_Id'],
         taskName : json['task_Name'],
         projectId : json['project_Id'],
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props {
    return [
        deadline,
        progress,
        userRole,
        name,
        taskDescription,
        taskCreatedDate,
        projectName,
        userId,
        taskId,
        taskName,
        projectId,
    ];
  }

}