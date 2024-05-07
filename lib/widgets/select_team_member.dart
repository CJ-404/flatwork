import 'package:flatwork/utils/utils.dart';
import 'package:flatwork/widgets/user_tile.dart';
import 'package:flatwork/widgets/widgets.dart';
import 'package:flutter/material.dart';
import '../config/routes/routes.dart';
import '../data/data.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flatwork/providers/providers.dart';

class SelectTeamMember extends ConsumerStatefulWidget {
  const SelectTeamMember({
    super.key,
    required this.assignedMembers
  });

  final List<User> assignedMembers;

  @override
  ConsumerState<SelectTeamMember> createState() => _SelectTeamMemberState();
}

class _SelectTeamMemberState extends ConsumerState<SelectTeamMember> {

  // @override
  // void dispose() {
  //   filterController.dispose();
  //   super.dispose();
  // }

  List<User> filterUsers(List<User> allUsers, String filterString){
    final availableUsers = allUsers.where((user) => !widget.assignedMembers.contains(user)).toList();
    if (filterString.isEmpty) {
      return availableUsers; // Return all users if no filter text
    }

    return availableUsers.where((user) => user.email.toLowerCase().contains(filterString.toLowerCase())).toList();
  }

  @override
  Widget build(BuildContext context) {
    //TODO: fetch all users from the backend
    // final users = ref.watch(usersProvider);
    final users = [
      User(
          id: 1,
          firstName: 'kasuns',
          lastName: 'gajanayaka',
          email: 'kasunGaje@gmail.com',
          contact: '0781232345'
      ),
      User(
          id: 2,
          firstName: 'kassdfun',
          lastName: 'gajanayaka',
          email: 'kasunGaje@gmail.com',
          contact: '0781232345'
      ),
      User(
          id: 3,
          firstName: 'kasun',
          lastName: 'gajasfdsnayaka',
          email: 'kasunGaje@gmail.com',
          contact: '0781232345'
      ),
      User(
          id: 4,
          firstName: 'kasun',
          lastName: 'gajanayaka',
          email: 'kasunGasdaje@gmail.com',
          contact: '0781232345'
      ),
      User(
          id: 4,
          firstName: 'kasun',
          lastName: 'gajanayaka',
          email: 'kasunGaje@gmail.com',
          contact: '0781232345'
      ),
      User(
          id: 4,
          firstName: 'kasun',
          lastName: 'gajanayaka',
          email: 'kasunGaje@gmail.com',
          contact: '0781232345'
      ),
      User(
          id: 4,
          firstName: 'kasun',
          lastName: 'gajanayaka',
          email: 'kasunGaje@gmail.com',
          contact: '0781232345'
      ),
    ];

    final userFilter = ref.watch(userFilterProvider);
    final TextEditingController filterController = TextEditingController();

    return SafeArea(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20.0),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16,
            top: 10,
            bottom: 10,
            right: 10,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonTextField(
                  // controller: filterController,
                  title: "Search by email",
                  hintText: userFilter==""? "Enter an email" : userFilter,
                  onChange: (value) {
                    //change userFilter
                    ref.read(userFilterProvider.notifier).state = value;
                  },
              ),
              SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DisplayListOfUsers(
                      assignedUsers: filterUsers(users,userFilter),
                      isSelect: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
