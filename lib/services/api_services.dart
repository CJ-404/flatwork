import 'dart:convert';
import 'package:flatwork/data/models/calendarTask.dart';
import 'package:flatwork/data/models/invitation.dart';
import 'package:flatwork/services/auth_services.dart';
import 'package:http/http.dart';
import 'package:flatwork/data/data.dart';

class ApiServices{
  // use 10.0.2.2 if running using the emulator

  // use your server machine ip address when mobile and server connected to the same network

  // debian ip in local WIFI
  // String endpoint = "http://192.168.1.39:8080/mpma/api/v1";

  // windows ip in local WIFI
  String endpoint = "http://192.168.1.3:8080/mpma/api/v1";
  static String accessToken = "";

  Future<List<Project>> getProjects() async {

    final userId = await AuthServices().getSavedUserId();
    final url = Uri.parse("$endpoint/project/get_all_projects_by_userID?userID=$userId");
    Response response = await get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer $accessToken",
      },
    )
    ;
    if (response.statusCode == 200){
      final List result = jsonDecode(response.body)['data'];
      // print(result);
      return result.map(((e) => Project.fromJson(e))).toList();
    }
    else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<Project> getProject(String projectId) async {
    final url = Uri.parse("$endpoint/project/get_project_by_project_id?projectID=$projectId");
    Response response = await get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer $accessToken",
      },
    );
    if (response.statusCode == 200){
      final result = jsonDecode(response.body)['data'];
      return Project.projectFromJson(result);
    }
    else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<List<File>> getProjectFiles(String projectId) async {
    final url = Uri.parse("$endpoint/file/getProjectFile?projectID=$projectId");
    Response response = await get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "*/*",
          "Authorization": "Bearer $accessToken",
        },
    );
    if (response.statusCode == 200){
      final List result = jsonDecode(response.body)['data'];
      return result.map(((data) => File.fromJson(data))).toList();
    }
    else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<List<Task>> getTasks(String projectId) async {
    final url = Uri.parse("$endpoint/task/get_all_tasks_by_project_id?projectID=$projectId");
    Response response = await get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "*/*",
          "Authorization": "Bearer $accessToken",
        },
    );
    print(response.statusCode);
    if (response.statusCode == 200){
      final List result = jsonDecode(response.body)['data'];
      return result.map(((e) => Task.fromJson(e))).toList();
    }
    else {
      throw Exception("server crashed : 405");
    }
  }

  Future<List<CalendarTask>> getAllTasksByUserId(String userId) async {
    final url = Uri.parse("$endpoint/task/get_all_tasks_by_user_id?userID=$userId");
    Response response = await get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer $accessToken",
      },
    );
    if (response.statusCode == 200){
      final List result = jsonDecode(response.body)['data'];
      return result.map(((e) => CalendarTask.fromJson(e))).toList();
    }
    else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<List<File>> getTaskFiles(String taskId) async {
    final url = Uri.parse("$endpoint/file/getTaskFile?taskId=$taskId");
    Response response = await get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer $accessToken",
      },
    );
    if (response.statusCode == 200){
      final List result = jsonDecode(response.body)['data'];
      return result.map(((data) => File.fromJson(data))).toList();
    }
    else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<Task> getTask(String taskId) async {
    final url = Uri.parse("$endpoint/task/get_task_by_id?taskID=$taskId");
    Response response = await get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer $accessToken",
      },
    );
    if (response.statusCode == 200){
      final result = jsonDecode(response.body)['data'];
      return Task.fromJson(result);
    }
    else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<List<User>> getProjectUsers(String projectId) async {
    final url = Uri.parse("$endpoint/user/get_all_project_user?projectID=$projectId");
    Response response = await get(
        url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer $accessToken",
      },
    );
    if (response.statusCode == 200){
      final List result = jsonDecode(response.body)['data'];
      return result.map(((e) => User.fromJson(e))).toList();
    }
    else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<List<User>> getAllUsers() async {
    final url = Uri.parse("$endpoint/user/get_all_users");
    Response response = await get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer $accessToken",
      },
    );
    if (response.statusCode == 200){
      final List result = jsonDecode(response.body)['data'];
      return result.map(((e) => User.fromJson(e))).toList();
    }
    else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<List<Invitation>> getInvitations(String userId) async {
    final url = Uri.parse("$endpoint/user/get_invitations?userID=$userId");
    Response response = await get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer $accessToken",
      },
    );
    if (response.statusCode == 200){
      final List result = jsonDecode(response.body)['data'];
      return result.map(((e) => Invitation.fromJson(e))).toList();
    }
    else {
      throw Exception(response.reasonPhrase);
    }
  }

  // Ignore for now
  Future<User> getUser(String userId) async {
    final url = Uri.parse("user/get_user_by_userID?userID=$userId");
    Response response = await get(
        url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer $accessToken",
      },
    );
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

    final url = Uri.parse("$endpoint/project/initialize_project");
    final userId = await AuthServices().getSavedUserId();
    final body =  jsonEncode({
      "userID": userId,
      "project_name": project.title,
      "project_description":project.description,
    });

    Response response = await post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "*/*",
          "Authorization": "Bearer $accessToken",
        },
        body: body
    );
    if (response.statusCode == 201){
      // final Map<String,dynamic> result = jsonDecode(response.body)['data'];
      // print(result);
      return true;
    }
    else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<bool> createProjectFile(String projectId, String fileName, String fileUrl) async {
    final url = Uri.parse("$endpoint/file/addProjectFile");
    final body =  jsonEncode({
      "fileName":fileName,
      "fileURL":fileUrl,
      "projectid": projectId,
    });
    Response response = await post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "*/*",
          "Authorization": "Bearer $accessToken",
        },
        body: body
    );
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
    final url = Uri.parse("$endpoint/project/create_task");
    final body =  jsonEncode({
      "task_name":task.title,
      "task_description":task.description,
      "project_id":projectId,
    });
    Response response = await post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "*/*",
          "Authorization": "Bearer $accessToken",
        },
        body: body
    );
    if (response.statusCode == 201){
      // final List result = jsonDecode(response.body)['data'];
      return true;
    }
    else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<bool> createTaskFile(String taskId, String fileName, String fileUrl) async {
    final url = Uri.parse("$endpoint/file/addTaskFile");
    final body =  jsonEncode({
      "fileName":fileName,
      "fileURL":fileUrl,
      "taskid": taskId,
    });
    Response response = await post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "*/*",
          "Authorization": "Bearer $accessToken",
        },
        body: body
    );
    if (response.statusCode == 201){
      // final List result = jsonDecode(response.body)['data'];
      return true;
    }
    else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<bool> sendInvitation(String userId, String projectId, String invitedUserId, int role) async {
    final url = Uri.parse("$endpoint/user/invite_to_member");
    final body =  jsonEncode({
      "userID": userId,
      "projectID": projectId,
      "invitedUserID": invitedUserId,
      "role": role, // 1 , 2
    });
    Response response = await post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer $accessToken",
      },
      body: body,
    );
    if (response.statusCode == 200 || response.statusCode == 201){
      // final List result = jsonDecode(response.body)['data'];
      return true;
    }
    else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<bool> removeUserFromProject(String projectId, String managerId, String userId) async {
    final url = Uri.parse("$endpoint/user/invite_to_member");
    final body =  jsonEncode({
      "projectID": projectId,
      "managerID": managerId,
      "userID": userId,
    });
    Response response = await post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer $accessToken",
      },
      body: body,
    );
    if (response.statusCode == 200 || response.statusCode == 201){
      // final List result = jsonDecode(response.body)['data'];
      return true;
    }
    else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<bool> acceptInvitation(String invitationId) async {
    final url = Uri.parse("$endpoint/user/accept_invitation?invitationID=$invitationId");
    // final body =  jsonEncode({});
    Response response = await post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "*/*",
          "Authorization": "Bearer $accessToken",
        },
    );
    if (response.statusCode == 200 || response.statusCode == 201){
      // final List result = jsonDecode(response.body)['data'];
      return true;
    }
    else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<bool> rejectInvitation(String invitationId) async {
    final url = Uri.parse("$endpoint/user/decline_invitation?invitationID=$invitationId");
    // final body =  jsonEncode({});
    Response response = await post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer $accessToken",
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201){
      // final List result = jsonDecode(response.body)['data'];
      return true;
    }
    else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<bool> updatePassword(String userId, String oldPassword, String newPassword) async {
    final url = Uri.parse("$endpoint/user/password_change");
    final body =  jsonEncode({
      "userID": userId,
      "oldPassword": oldPassword,
      "newPassword": newPassword,
    });
    Response response = await put(
      url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer $accessToken",
      },
      body: body,
    );
    if (response.statusCode == 200 || response.statusCode == 201){
      // final List result = jsonDecode(response.body)['data'];
      return true;
    }
    else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<bool> updateUser(String userId, String firstName, String lastName, String contact ) async {
    final url = Uri.parse("$endpoint/user/update_user");
    final body =  jsonEncode({
      "user_id": userId,
      "first_name": firstName,
      "last_name": lastName,
      "contact": contact,
    });
    Response response = await put(
      url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer $accessToken",
      },
      body: body,
    );
    if (response.statusCode == 200 || response.statusCode == 201){
      // final List result = jsonDecode(response.body)['data'];
      return true;
    }
    else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<bool> updateUserRole(String ownerUserId, String userId, String projectId, int role ) async {
    final url = Uri.parse("$endpoint/user/update_user");
    final body =  jsonEncode({
      "projectOwnerID": ownerUserId,
      "userID": userId,
      "projectID": projectId,
      "role": role //1:Manager,2:Team Member
    });
    Response response = await put(
      url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer $accessToken",
      },
      body: body,
    );
    if (response.statusCode == 200 || response.statusCode == 201){
      // final List result = jsonDecode(response.body)['data'];
      return true;
    }
    else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<bool> updateTaskProgress(String taskId, double progressValue) async {
    final url = Uri.parse("$endpoint/task/updateTaskProgress");
    final body =  jsonEncode({
      "taskId": taskId,
      "progressPercentage": progressValue,
    });
    Response response = await put(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "*/*",
          "Authorization": "Bearer $accessToken",
        },
        body: body
    );
    if (response.statusCode == 200){
      final bool result = jsonDecode(response.body)['data'];
      print(result);
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
    final url = Uri.parse("$endpoint/task/assign_team_member_to_task");
    final body =  jsonEncode({
      "taskID":taskId,
      "teamMemberID":user.id,
    });
    Response response = await put(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "*/*",
          "Authorization": "Bearer $accessToken",
        },
        body: body
    );
    if (response.statusCode == 200){
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
    final url = Uri.parse("$endpoint/task/remove_team_member_from_task");
    final body =  jsonEncode({
      "taskID":taskId,
      "teamMemberID":userId,
    });
    Response response = await put(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "*/*",
          "Authorization": "Bearer $accessToken",
        },
        body: body
    );
    if (response.statusCode == 200){
      // final List result = jsonDecode(response.body)['data'];
      return true;
    }
    else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<Map<String, dynamic>?> login(String email, String password) async {

    try {
      final url = Uri.parse("$endpoint/user/login");
      final body =  jsonEncode({
        'email': email,
        'password': password
      });

      Response response1 = await post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "*/*",
        },
        body: body
      );
      Response response2;

      if (response1.statusCode == 200){

        final Map<String, dynamic> jsonResponse = jsonDecode(response1.body)['data'];

        final String userId = jsonResponse['user_id'];
        accessToken = jsonResponse['access_token'];

        // Print each data item
        // print('User ID: $userId');
        // print('Access Token: $accessToken');

        final url = Uri.parse("$endpoint/user/get_user_by_userID?userID=$userId");
        response2 = await get(
            url,
            headers: {
              "Content-Type": "application/json",
              "Accept": "*/*",
              "Authorization": "Bearer $accessToken",
            },
        );

        if (response2.statusCode == 200) {

          // final Map<String, dynamic> jsonResponse = jsonDecode(response2.body);
          // final user = User.fromJson(jsonResponse['data']);

          final Map<String, dynamic> result = {
            'res' : response2,
            'access_token' : accessToken,
          };

          return result;
        }
        else {
          throw Exception(response2.reasonPhrase);
        }
      }
      else {
        throw Exception(response1.reasonPhrase);
      }

    } catch (e) {
      // print(e);
      throw Exception('Failed to get login request response');
    }
  }

  Future<bool?> signup(String fname, String lname, String email, String password, String contactNo) async {
    try {

      final url = Uri.parse("$endpoint/user/user_sign_up");
      final body =  jsonEncode({
        "first_name": fname,
        "last_name": lname,
        "email": email,
        "contact":contactNo,
        "password": password,
      });
      Response response = await post(
          url,
          headers: {
            "Content-Type": "application/json",
            "Accept": "*/*",
          },
          body: body
      );
      if (response.statusCode == 201){
        return true;
      }
      else {
        throw Exception(response.reasonPhrase);
      }

    } catch (e) {
      // print(e);
      throw Exception('Failed to get signup request response');
    }
  }
}