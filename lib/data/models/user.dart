import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String? id;
  final String firstName;
  final String lastName;
  final String email;
  final String? role; //TODO: role should be  required field
  // final String contact;

  const User( {
    this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.role,
    // required this.contact,
  });

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      id: json['user_id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      // contact: json['contact'],
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
      firstName,
      lastName,
      email,
      // contact,
    ];
  }

}