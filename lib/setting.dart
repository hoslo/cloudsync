import 'dart:developer';

import 'package:cloudsync/main.dart';
import 'package:cloudsync/setting/cos.dart';
import 'package:cloudsync/setting/s3.dart';
import 'package:cloudsync/src/rust/api/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pull_down_button/pull_down_button.dart';

class Setting extends StatelessWidget {
  const Setting({super.key});


  get onPressed => null;
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CloudController>();

    final settings = {
      "S3": S3Setting(
        
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

class EditSetting extends StatelessWidget {
  final int configId;
  final ServiceType serviceType;

  const EditSetting(
      {super.key, required this.configId, required this.serviceType});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: CupertinoPageScaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: CupertinoColors.systemGroupedBackground,
            child: SingleChildScrollView(child: Center(
              child: Container(
                margin: const EdgeInsets.only(top: 20),
                child: Builder(builder: (context) {
                  switch (serviceType) {
                    case ServiceType.s3:
                      return S3Setting(
                        id: configId,
                      );
                    default:
                      return const S3Setting();
                  }
                }),
              ),
            ))));
  }
}
