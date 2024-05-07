import 'package:flatwork/utils/utils.dart';
import 'package:flatwork/widgets/widgets.dart';
import 'package:flutter/material.dart';
import '../data/data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/loading_provider.dart';
import '../providers/providers.dart';
import '../services/api_services.dart';


class DisplayListOfUsers extends ConsumerWidget {
  const DisplayListOfUsers({
    super.key,
    required this.assignedUsers,
    this.isSelect=false,
    required this.scaffoldKey,
  });

  final List<User> assignedUsers;
  final bool? isSelect;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceSize = context.deviceSize;
    final emptyUsersMessage = isSelect!? "There are no users found" : "haven't assigned an user yet";

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
                  await _assignUser(assignedUser, ref);
                  ref.read(userFilterProvider.notifier).state = "";
                  ref.refresh(taskProvider);
                  Navigator.pop(scaffoldKey.currentContext!);
                }

              },
              child: !isSelect!?
                    UserTile(user: assignedUser, isSelect: isSelect!, onDelete: (){_removeMember(assignedUser.id.toString(), ref);},)
                        :
                    UserTile(user: assignedUser, isSelect: isSelect!),
          );
        }, separatorBuilder: (BuildContext context, int index) {
        return const Divider(thickness: 1.5,);
      },
      ),
    );
  }

  Future<bool> _assignUser(User user, WidgetRef ref) async {

    ref.read(loadingProvider.notifier).state = true;
    try{
      final String taskId = ref.watch(taskIdProvider);
      final response = await ApiServices().assignTeamMember(
        user,
        taskId,
      );
      if(response){
        ref.read(loadingProvider.notifier).state = false;
        if( scaffoldKey.currentState != null) {
          ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(
            const SnackBar(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // mainAxisSize: MainAxisSize.min,
                children: [
                  Text('New team member added!'),
                  SizedBox(width: 10),
                  Icon(Icons.check_box_outlined, color: Colors.black54),
                ],
              ),
              backgroundColor: Colors.green,
            ),
          );
        }
        return true;
      }
      else{
        ref.read(loadingProvider.notifier).state = false;
        if(scaffoldKey.currentState != null) {
          ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(
            const SnackBar(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Check your Network Connection and Try Again'),
                  SizedBox(width: 10),
                  Icon(Icons.error_outline_rounded, color: Colors.black54),
                ],
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
    catch (e){
      // print(e.toString());
      ref.read(loadingProvider.notifier).state = false;
      final errorMessage = e.toString();
      if(scaffoldKey.currentState != null) {
        ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(
          SnackBar(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  errorMessage,
                  style: const TextStyle(
                      fontSize: 8
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(Icons.error_outline_rounded, color: Colors.black54),
              ],
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    return false;
  }

  Future<bool> _removeMember(String userId, WidgetRef ref) async {

    ref.read(loadingProvider.notifier).state = true;
    try{
      final String taskId = ref.watch(taskIdProvider);
      final response = await ApiServices().removeAssignedTeamMember(userId, taskId);
      if(response){
        ref.read(loadingProvider.notifier).state = false;
        if( scaffoldKey.currentState != null) {
          ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(
            const SnackBar(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Removed team member!'),
                  SizedBox(width: 10),
                  Icon(Icons.check_box_outlined, color: Colors.black54),
                ],
              ),
              backgroundColor: Colors.green,
            ),
          );
        }
        ref.refresh(taskProvider);
        return true;
      }
      else{
        ref.read(loadingProvider.notifier).state = false;
        if(scaffoldKey.currentState != null) {
          ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(
            const SnackBar(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Check your Network Connection and Try Again'),
                  SizedBox(width: 10),
                  Icon(Icons.error_outline_rounded, color: Colors.black54),
                ],
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
    catch (e){
      // print(e.toString());
      ref.read(loadingProvider.notifier).state = false;
      final errorMessage = e.toString();
      if(scaffoldKey.currentState != null) {
        ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(
          SnackBar(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  errorMessage,
                  style: const TextStyle(
                      fontSize: 8
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(Icons.error_outline_rounded, color: Colors.black54),
              ],
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    return false;
  }
}
