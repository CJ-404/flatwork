import 'package:flatwork/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:gap/gap.dart';

class SharedFileTile extends StatelessWidget {
  const SharedFileTile({super.key, required this.fileName, required this.url});

  final String fileName;
  final String url;

  @override
  Widget build(BuildContext context) {
    final style = context.textTheme;
    final colors = context.colorScheme;

    return Row(
      children: [
        const Gap(16),
        Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  style: style.titleMedium?.copyWith(
                    fontWeight: FontWeight.normal,
                    fontSize: 17,
                  ),
                ),
              ],
            )),
        IconButton(
          icon: Icon(Icons.download, color: colors.primary,size: 25,),
          onPressed: () async {
            //TODO: download from url
            final file = await FileDownloader.downloadFile(
                url: url,
                name: fileName,
                onProgress: (name, progress) {
                  print ("nam: $name, progress: $progress");
                },
                onDownloadCompleted: (path){
                  print('Path: $path');
                }
            );
            // Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    Text((file == null)? "file not downloaded" : "file downloaded"),
                    const SizedBox(width: 10),
                    Icon( (file == null)? Icons.error_outline_rounded : Icons.check_box_outlined, color: Colors.black54),
                  ],
                ),
                backgroundColor: (file == null)? Colors.red : Colors.green,
              ),
            );
          },
        ),
      ],
    );
  }
}
