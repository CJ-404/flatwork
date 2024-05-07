import 'package:equatable/equatable.dart';
import 'package:flatwork/data/data.dart';

class User extends Equatable {
  final int? id;
  final String firstName;
  final String lastName;
  final String email;
  final String contact;

  const User( {
    this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.contact,
  });

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      contact: json['contact'],
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
      contact,
    ];
  }

}