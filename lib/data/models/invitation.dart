import 'package:equatable/equatable.dart';

class Invitation extends Equatable {
  final String id;
  final String sentBy;
  final String projectId;
  final String guestId;
  final String? role;
  final String message;

  const Invitation( {
    required this.id,
    required this.sentBy,
    required this.projectId,
    required this.guestId,
    this.role,
    required this.message,
  });

  factory Invitation.fromJson(Map<String, dynamic> json){
    return Invitation(
      id: json['invitationID'],
      sentBy: json['invitationSendBy'],
      projectId: json['projectName'],
      guestId: json['guestID'],
      role: json['role'],
      message: json['message'],
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props {
    return [
      id,
      sentBy,
      projectId,
      guestId,
      role,
      message,
    ];
  }

}