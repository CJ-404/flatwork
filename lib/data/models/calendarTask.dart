import 'package:equatable/equatable.dart';

class CalendarTask extends Equatable {
  final String deadline;
  final int progress;
  final String userRole;
  final String name;
  final String taskDescription;
  final String taskCreatedDate;
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
         deadline : json[''],
         progress : json[''],
         userRole : json[''],
         name : json[''],
         taskDescription : json[''],
         taskCreatedDate : json[''],
         projectName : json[''],
         userId : json[''],
         taskId : json[''],
         taskName : json[''],
         projectId : json[''],
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