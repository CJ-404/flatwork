import 'package:flatwork/widgets/widgets.dart';
import 'package:flutter/material.dart';
import '../data/data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flatwork/providers/providers.dart';

class SelectTeamMember extends ConsumerStatefulWidget {
  const SelectTeamMember({
    super.key,
    required this.assignedMembers,
    required this.scaffoldKey,
  });

  final List<User> assignedMembers;
  final GlobalKey<ScaffoldState> scaffoldKey;

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
    final availableUsers = allUsers.where((user) => widget.assignedMembers.where((assignedMember) => assignedMember.id == user.id ).toList().isEmpty ).toList();
    if (filterString.isEmpty) {
      return availableUsers; // Return all users if no filter text
    }

    return availableUsers.where((user) => user.email.toLowerCase().contains(filterString.toLowerCase())).toList();
  }

  @override
  Widget build(BuildContext context) {
    final fetchedUsers = ref.watch(usersProvider);

    final userFilter = ref.watch(userFilterProvider);
    // final TextEditingController filterController = TextEditingController();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
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
                fetchedUsers.when(
                    data: (fetchedUsers){
                      List<User> users = fetchedUsers;
                      return SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            DisplayListOfUsers(
                              assignedUsers: filterUsers(users,userFilter),
                              isSelect: true,
                              scaffoldKey: widget.scaffoldKey,
                              parentRef: ref,
                            ),
                          ],
                        ),
                      );
                    },
                    error: (err, s) => Text(err.toString()),
                    loading: () => const Center(
                      child: CircularProgressIndicator(),
                    )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
