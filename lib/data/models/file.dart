import 'dart:ffi';

import 'package:equatable/equatable.dart';

class File extends Equatable {
  final String id;
  final String name;
  final String url;

  const File({
    required this.id,
    required this.name,
    required this.url,
  });

  factory File.fromJson(Map<String, dynamic> json){
    return File(
      id: json['fileID'],
      name: json['fileName'],
      url: json['url'],
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
      id,
      name,
      url,
    ];
  }

}