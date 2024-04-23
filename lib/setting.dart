import 'dart:ffi';

import 'package:cloudsync/main.dart';
import 'package:cloudsync/setting/cos.dart';
import 'package:cloudsync/setting/s3.dart';
import 'package:cloudsync/src/rust/api/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:pull_down_button/pull_down_button.dart';

class Setting extends StatelessWidget {
  const Setting(this.goToCloud, {super.key});

  final VoidCallback goToCloud;

  get onPressed => null;
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CloudController>();

    final settings = {
      "S3": S3Setting(
        goToCloud: goToCloud,
      ),
      "COS": CosSetting(
        goToCloud: goToCloud,
      ),
    };

    return SafeArea(
      child: CupertinoPageScaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: CupertinoColors.systemGroupedBackground,
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Center(
                    child: PullDownButton(
                      buttonBuilder: (context, showMenu) => CupertinoButton(
                        onPressed: showMenu,
                        padding: EdgeInsets.zero,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              controller.selectService.value,
                              style: const TextStyle(
                                color: CupertinoColors.systemBlue,
                                fontSize: 18,
                              ),
                            ),
                            const Icon(
                              CupertinoIcons.chevron_down,
                              color: CupertinoColors.systemBlue,
                            ),
                          ],
                        ),
                      ),
                      itemBuilder: (context) {
                        return settings.keys
                            .toList()
                            .map((e) => PullDownMenuItem(
                                title: e,
                                onTap: () {
                                  controller.selectService.value = e;
                                }))
                            .toList();
                      },
                    ),
                  ),
                  Center(
                 
                      child: Obx(() => settings[controller.selectService.value]!),
                    
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
