import 'dart:io';
import 'dart:typed_data';

import 'package:cloudsync/main.dart';
import 'package:cloudsync/src/rust/api/cloud_service.dart';
import 'package:cloudsync/widgets/listile.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FileView extends StatelessWidget {
  const FileView({super.key});

  @override
  Widget build(BuildContext context) {
    final cloudController = Get.find<CloudController>();
    Get.lazyPut<FileController>(() => FileController());
    final controller = Get.find<FileController>();
    controller.listFile(cloudController.path.value);
    return SafeArea(
        child: Scaffold(
            backgroundColor: CupertinoColors.systemGroupedBackground,
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                FilePickerResult? result =
                    await FilePicker.platform.pickFiles();

                if (result != null) {
                  File file = File(result.files.single.path!);
                } else {
                  print("No file selected");
                }
              },
              shape: const CircleBorder(),
              child: const Icon(CupertinoIcons.cloud_upload),
            ),
            body: controller.obx(
              (state) {
                final entries = state!;
                return ListView.separated(
                    itemBuilder: (_, index) {
                      final entry = entries[index];
                      return CupertinoContextMenu.builder(
                          // ignore: deprecated_member_use
                          // previewBuilder: (BuildContext context,
                          //     Animation<double> animation, Widget child) {
                          //   return SingleChildScrollView(
                          //     child: EntryTile(entry: entry),
                          //   );
                          // },
                          enableHapticFeedback: true,
                          actions: [
                            CupertinoContextMenuAction(
                              onPressed: () {
                                final file =
                                    CloudService.read(path: entry.path);
                                Uint8List bs = Uint8List(0);
                                file.then((value) => bs = value);
                                print('length: ${bs.length}');
                                // await File(outputFile).writeAsBytes(bs);
                                final result = FileSaver.instance.saveFile(
                                  name: entry.path,
                                  bytes: bs,
                                );
                                print('result :$result');
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                                //   FilePickerResult? result = await FilePicker.platform.pickFiles();

                                // if (result != null) {
                                //   File file = File(result.files.single.path!);
                                // } else {
                                //   print("No file selected");
                                // }
                                // download file to outputFile
                              },
                              // isDefaultAction: true,
                              trailingIcon: CupertinoIcons.cloud_download,
                              child: const Text('Download'),
                            ),
                          ],
                          builder: (context, animation) {
                            return SingleChildScrollView(
                                child: EntryTile(entry: entry));
                          });
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
