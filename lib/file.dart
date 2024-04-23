import 'package:cloudsync/main.dart';
import 'package:cloudsync/src/rust/api/config.dart';
import 'package:file_icon/file_icon.dart';
import 'package:file_picker/file_picker.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FileView extends StatelessWidget {
  const FileView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut<FileController>(() => FileController());
    final controller = Get.find<FileController>();
    final cloudController = Get.find<CloudController>();
    controller.listFile(cloudController.path.value);
    return SafeArea(
        child: Scaffold(
            backgroundColor: CupertinoColors.systemGroupedBackground,
            floatingActionButton: CupertinoButton(
                child: const Text("save"),
                onPressed: () async {
                  // controller.clearCache();
                  // Get.delete<FileController>();
                  // Navigator.of(context).pushAndRemoveUntil(
                  //     CupertinoPageRoute(builder: (context) {
                  //   return const FileView(
                  //     path: "/",
                  //   );
                  // }), (Route<dynamic> route) => false);
                  String? outputFile = await FilePicker.platform.saveFile(
                    dialogTitle: 'Please select an output file:',
                    fileName: 'output-file.pdf',
                  );

                  if (outputFile == null) {
                    // User canceled the picker
                  }
                  print('output file $outputFile');
                  return;
                }),
            body: controller.obx(
              (state) {
                final entries = state!;
                return ListView.separated(
                    itemBuilder: (_, index) {
                      final entry = entries[index];
                      final size = filesize(entry.contentLength);
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
                        // textColor: CupertinoColors.black,
                        subtitle: Text(size),
                        // style: ListTileStyle.list,
                        // tileColor: CupertinoColors.systemBackground,
                        onTap: () async {
                          print('tap ${entry.path} ');

                          Get.delete<FileController>();
                          cloudController.path.value = entry.path;
                          Navigator.of(context)
                              .push(CupertinoPageRoute(builder: (context) {
                            return FileView();
                          }));

                          // Get.to(() => FileView(path: entry.path,),
                          //     arguments:  entry.path,
                          //     preventDuplicates: false);
                          // print('route name ${ModalRoute.of(context)}');
                        },
                      );
                    },
                    separatorBuilder: (_, index) {
                      return const Divider();
                    },
                    itemCount: entries.length);
              },
              onLoading: const Center(child: CupertinoActivityIndicator()),
              onError: (error) {
                return Center(
                    child: Text(
                  error.toString(),
                  style: const TextStyle(color: Colors.red),
                ));
              },
            )));
  }
}
