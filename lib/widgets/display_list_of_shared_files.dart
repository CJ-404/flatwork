import 'package:flatwork/providers/providers.dart';
import 'package:flatwork/utils/utils.dart';
import 'package:flatwork/widgets/shared_file_tile.dart';
import 'package:flatwork/widgets/widgets.dart';
import 'package:flutter/material.dart';
import '../config/routes/routes.dart';
import '../data/data.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DisplayListOfSharedFiles extends StatelessWidget {
  const DisplayListOfSharedFiles({
    super.key,
    required this.sharedFiles,
    required this.ref
  });

  final List<String> sharedFiles;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final deviceSize = context.deviceSize;
    const emptyTasksMessage = "empty";

    return CommonContainer(
      height: deviceSize.height*0.4,
      color: context.colorScheme.onPrimary,
      child: sharedFiles.isEmpty?
      Center(
        child: Text(
          emptyTasksMessage,
          style: context.textTheme.headlineSmall,
        ),
      )
          :
      ListView.separated(
        shrinkWrap: true,
        itemCount: sharedFiles.length,
        itemBuilder: (ctx, index) {
          final sharedFile = sharedFiles[index];

          return SharedFileTile(
            fileName: sharedFile,
          );
        }, separatorBuilder: (BuildContext context, int index) {
        return const Divider(thickness: 1.0,);
      },
      ),
    );
  }
}
