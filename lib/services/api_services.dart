
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:flatwork/data/data.dart';

class ApiServices{
  String endpoint = "http://localhost:8080/mpma/api/v1/";

  Future<List<Project>> getProjects() async {
    final url = Uri.parse("$endpoint/project/get_all_projects");
    Response response = await get(url);
    if (response.statusCode == 200){
      final List result = jsonDecode(response.body)['data'];
      return result.map(((e) => Project.fromJson(e))).toList();
    }
    else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<Project> getProject(String projectId) async {
    final url = Uri.parse("project/$endpoint?projectID=$projectId");
    Response response = await get(url);
    if (response.statusCode == 200){
      final result = jsonDecode(response.body)['data'];
      return Project.fromJson(result);
    }
    else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<List<Task>> getTasks(String projectId) async {
    final url = Uri.parse("${endpoint}task/get_all_tasks_by_project_id?projectID=$projectId");
    Response response = await get(url);
    if (response.statusCode == 200){
      final List result = jsonDecode(response.body)['data'];
      return result.map(((e) => Task.fromJson(e))).toList();
    }
    else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<Task> getTask(String taskId) async {
    final url = Uri.parse("task/$endpoint?taskID=$taskId");
    Response response = await get(url);
    if (response.statusCode == 200){
      final result = jsonDecode(response.body)['data'];
      return Task.fromJson(result);
    }
    else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<List<User>> getUsers() async {
    final url = Uri.parse("${endpoint}user/get_all_users");
    Response response = await get(url);
    if (response.statusCode == 200){
      final List result = jsonDecode(response.body)['data'];
      return result.map(((e) => User.fromJson(e))).toList();
    }
    else {
      throw Exception(response.reasonPhrase);
    }
  }

  // Ignore for now
  Future<User> getUser(String userId) async {
    final url = Uri.parse("user/$endpoint?userID=$userId");
    Response response = await get(url);
    if (response.statusCode == 200){
      final result = jsonDecode(response.body)['data'];
      return User.fromJson(result);
    }
    else {
      throw Exception(response.reasonPhrase);
    }
  }

  // Future<List<User>> getAssignedUsers(String taskId) async {
  //   final url = Uri.parse("${endpoint}user/get_assigned_users?taskID=$taskId");
  //   Response response = await get(url);
  //   if (response.statusCode == 200){
  //     final List result = jsonDecode(response.body)['data'];
  //     return result.map(((e) => User.fromJson(e))).toList();
  //   }
  //   else {
  //     throw Exception(response.reasonPhrase);
  //   }
  // }

  // {
  // "project_name":"test project 1",
  // "project_description":"test_project_description"
  // }
  Future<bool> createProject(Project project) async {
    final url = Uri.parse("${endpoint}project/initialize_project");
    final body =  {
      "project_name": project.title,
      "project_description":project.description,
    };
    Response response = await post(url,body: body);
    if (response.statusCode == 201){
      // final List result = jsonDecode(response.body)['data'];
      return true;
    }
    else {
      throw Exception(response.reasonPhrase);
    }
  }

  // {
  // "task_name":"test task3",
  // "task_description":"test task description",
  // "project_id":"1954a51d-5"
  // }
  Future<bool> addTask(Task task, String projectId) async {
    final url = Uri.parse("${endpoint}project/create_task");
    final body =  {
      "task_name":task.title,
      "task_description":task.description,
      "project_id":projectId,
    };
    Response response = await post(url,body: body);
    if (response.statusCode == 201){
      // final List result = jsonDecode(response.body)['data'];
      return true;
    }
    else {
      throw Exception(response.reasonPhrase);
    }
  }

  // {
  // "taskID":"67ac088b-45",
  // "teamMemberID":"2da64477"
  // }
  Future<bool> assignTeamMember(User user, String taskId) async {
    final url = Uri.parse("${endpoint}task/assign_team_member_to_task");
    final body =  {
      "taskID":taskId,
      "teamMemberID":user.id,
    };
    Response response = await put(url,body: body);
    if (response.statusCode == 201){
      // final List result = jsonDecode(response.body)['data'];
      return true;
    }
    else {
      throw Exception(response.reasonPhrase);
    }
  }

  // {
  // "taskID":"67ac088b-45",
  // "teamMemberID":"2da64477"
  // }
  Future<bool> removeAssignedTeamMember(String userId, String taskId) async {
    final url = Uri.parse("${endpoint}task/remove_team_member_from_task");
    final body =  {
      "taskID":taskId,
      "teamMemberID":userId,
    };
    Response response = await put(url,body: body);
    if (response.statusCode == 201){
      // final List result = jsonDecode(response.body)['data'];
      return true;
    }
    else {
      throw Exception(response.reasonPhrase);
    }
  }
}