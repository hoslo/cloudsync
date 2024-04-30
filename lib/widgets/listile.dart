import 'package:cloudsync/file.dart';
import 'package:cloudsync/main.dart';
import 'package:cloudsync/src/rust/api/config.dart';
import 'package:file_icon/file_icon.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

String getEntrgetyName(Entry entry) {
  final paths = entry.path.split('/');
  if (entry.mode == EntryMode.file) {
    return paths.last;
  }
  return paths[paths.length - 2];
}

class EntryTile extends StatelessWidget {
  const EntryTile({super.key, required this.entry});

  final Entry entry;

  @override
  Widget build(BuildContext context) {
    final size = filesize(entry.contentLength);
    final cloudController = Get.find<CloudController>();
    final name = getEntrgetyName(entry);
    print('orgin path ${entry.path}, name $name');
    return CupertinoListTile(
      leading: entry.mode == EntryMode.file
          ? FileIcon(
              entry.path,
              // size: c.entries[index].contentLength as double,
            )
          : const Icon(Icons.folder),
      title: LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            width: constraints.maxWidth - 50,
            child: Text(
              name,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          );
        },
      ),
      subtitle: Text(size),
      onTap: () async {
        if (entry.mode == EntryMode.file) {
          return;
        }
        Get.delete<FileController>();
        cloudController.path.value = entry.path;
        Navigator.of(context).push(CupertinoPageRoute(builder: (context) {
          return const FileView();
        }));
      },
    );
  }
}
