import 'package:cloudsync/file.dart';
import 'package:cloudsync/main.dart';
import 'package:cloudsync/src/rust/api/config.dart';
import 'package:file_icon/file_icon.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EntryTile extends StatelessWidget {
  const EntryTile({super.key, required this.entry});

  final Entry entry;

  @override
  Widget build(BuildContext context) {
    final size = filesize(entry.contentLength);
    final cloudController = Get.find<CloudController>();
    return CupertinoListTile(
      leading: entry.mode == EntryMode.file
          ? FileIcon(
              entry.path,
              // size: c.entries[index].contentLength as double,
            )
          : const Icon(Icons.folder),
      title: Text(
        entry.path.length > 40
            ? '${entry.path.substring(0, 9)}...${entry.path.substring(entry.path.length - 10)}'
            : entry.path,
        maxLines: 1,
      ),
      subtitle: Text(size),
      onTap: () async {
        if (entry.mode == EntryMode.file) {
          return;
        }
        print('tap ${entry.path} ');

        Get.delete<FileController>();
        cloudController.path.value = entry.path;
        Navigator.of(context).push(CupertinoPageRoute(builder: (context) {
          return const FileView();
        }));
      },
    );
  }
}
