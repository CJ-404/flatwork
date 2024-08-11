import 'package:flatwork/utils/utils.dart';
import 'package:flatwork/widgets/shared_file_tile.dart';
import 'package:flatwork/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DisplayListOfSharedFiles extends StatelessWidget {
  const DisplayListOfSharedFiles({
    super.key,
    required this.sharedFilesLinks,
    required this.ref
  });

  final List<String> sharedFilesLinks;
  final WidgetRef ref;

  // TODO: fetch file names for links from firebase
  // late List<String> sharedFilesNames;

  @override
  Widget build(BuildContext context) {
    final deviceSize = context.deviceSize;
    const emptyTasksMessage = "empty";

    return CommonContainer(
      height: deviceSize.height*0.4,
      color: context.colorScheme.onPrimary,
      child: sharedFilesLinks.isEmpty?
      Center(
        child: Text(
          emptyTasksMessage,
          style: context.textTheme.headlineSmall,
        ),
      )
          :
      ListView.separated(
        shrinkWrap: true,
        itemCount: sharedFilesLinks.length,
        itemBuilder: (ctx, index) {
          final sharedFileLink = sharedFilesLinks[index];

          return SharedFileTile(
            fileName: sharedFileLink, url: sharedFileLink,
          );
        }, separatorBuilder: (BuildContext context, int index) {
        return const Divider(thickness: 1.0,);
      },
      ),
    );
  }
}
