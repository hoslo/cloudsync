import 'dart:io';

import 'package:cloudsync/main.dart';
import 'package:cloudsync/src/rust/api/cloud_service.dart';
import 'package:cloudsync/widgets/listile.dart';
import 'package:file_picker/file_picker.dart';
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
        child: CupertinoPageScaffold(
            backgroundColor: CupertinoColors.systemGroupedBackground,
            child: controller.obx(
              (state) {
                final entries = state!;
                return ListView.separated(
                    itemBuilder: (_, index) {
                      final entry = entries[index];
                      return CupertinoContextMenu(
                        // ignore: deprecated_member_use
                        previewBuilder: (BuildContext context,
                            Animation<double> animation, Widget child) {
                          return SingleChildScrollView(
                            child: EntryTile(entry: entry),
                          );
                        },
                        actions: [
                          CupertinoContextMenuAction(
                            onPressed: () async {
                              String? outputFile =
                                  await FilePicker.platform.saveFile(
                                dialogTitle: 'Please select an output file:',
                                fileName: 'output-file.pdf',
                              );

                              if (outputFile == null) {
                                // User canceled the picker
                                Get.snackbar(
                                    "Error", "No output file selected");
                                return;
                              }
                              // download file to outputFile
                              final bs =
                                  await CloudService.read(path: entry.path);
                              print('downloading file to $outputFile, length: ${bs.length}');
                              await File(outputFile).writeAsBytes(bs);
                            },
                            isDefaultAction: true,
                            trailingIcon: CupertinoIcons.cloud_download,
                            child: const Text('Download'),
                          ),
                        ],
                        child: SingleChildScrollView(
                          child: EntryTile(entry: entry),
                        ),
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
