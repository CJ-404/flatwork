import 'package:flatwork/utils/utils.dart';
import 'package:flatwork/widgets/user_tile.dart';
import 'package:flatwork/widgets/widgets.dart';
import 'package:flutter/material.dart';
import '../config/routes/routes.dart';
import '../data/data.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';
import '../services/api_services.dart';


class DisplayListOfUsers extends ConsumerWidget {
  const DisplayListOfUsers({
    super.key,
    required this.assignedUsers,
    this.isSelect=false,
  });

  final List<User> assignedUsers;
  final bool? isSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceSize = context.deviceSize;
    final emptyUsersMessage = isSelect!? "There are no users found" : "There are no team members yet";

    return CommonContainer(
      height: isSelect!? deviceSize.height*0.3 : deviceSize.height*0.48,
      color: context.colorScheme.onPrimary,
      child: assignedUsers.isEmpty?
      Center(
        child: Text(
          emptyUsersMessage,
          style: context.textTheme.headlineSmall!.copyWith(
            fontSize: 18,
          ),
        ),
      )
          :
      ListView.separated(
        shrinkWrap: true,
        itemCount: assignedUsers.length,
        itemBuilder: (ctx, index) {
          final assignedUser = assignedUsers[index];

          return InkWell(
              onTap: () async {
                if (isSelect!){
                  await _assignUser(assignedUser, ref.watch(taskIdProvider));
                  ref.read(userFilterProvider.notifier).state = "";
                  Navigator.pop(context);
                }

              },
              child: !isSelect!?
                    UserTile(user: assignedUser, isSelect: isSelect!, onDelete: (){_removeMember(assignedUser.id.toString(), ref.watch(taskIdProvider));},)
                        :
                    UserTile(user: assignedUser, isSelect: isSelect!),
          );
        }, separatorBuilder: (BuildContext context, int index) {
        return const Divider(thickness: 1.5,);
      },
      ),
    );
  }

  Future<bool> _assignUser(User user, String taskId) async {
    final response = await ApiServices().assignTeamMember(
      user,
      taskId,
    );

    if(response){
      //TODO: message
      return true;
    }
    else{
      //TODO: message
      return false;
    }
  }

  void _removeMember(String userId,String taskId) async {
    final response = await ApiServices().removeAssignedTeamMember(userId, taskId);

    if(response){
      //TODO: message
    }
    else{
      //TODO: message
    }
  }
}
