import 'package:flatwork/utils/utils.dart';
import 'package:flatwork/widgets/shared_file_tile.dart';
import 'package:flatwork/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DisplayListOfSharedFiles extends StatelessWidget {
  const DisplayListOfSharedFiles({
    super.key,
    required this.sharedFileLinks,
    required this.ref
  });

  final List<String> sharedFileLinks;
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
      child: sharedFileLinks.isEmpty?
      Center(
        child: Text(
          emptyTasksMessage,
          style: context.textTheme.headlineSmall,
        ),
      )
          :
      FutureBuilder<List<String>>(
        future: FileManager().getFileNames(sharedFileLinks),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
            // } else if (!snapshot.hasData || snapshot.data!['token'] == null) {
            //   return Center(child: Text('User data not found.'));
          } else {
            final sharedFileNames = snapshot.data!;
            return ListView.separated(
              shrinkWrap: true,
              itemCount: sharedFileNames.length,
              itemBuilder: (ctx, index) {
                final sharedFileLink = sharedFileLinks[index];
                final sharedFileName = sharedFileNames[index];

                return SharedFileTile(
                  fileName: sharedFileName, url: sharedFileLink,
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider(thickness: 1.0,);
              },
            );
          }
        },
      ),
    );
  }
}
