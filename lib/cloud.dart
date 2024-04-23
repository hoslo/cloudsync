import 'package:cloudsync/main.dart';
import 'package:cloudsync/setting.dart';
import 'package:cloudsync/src/rust/api/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:pull_down_button/pull_down_button.dart';

class Cloud extends StatelessWidget {
  const Cloud(this.goToFile, {super.key});

  final VoidCallback goToFile;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CloudController>();
    return SafeArea(
      child: Scaffold(
        backgroundColor: CupertinoColors.systemGroupedBackground,
        body: controller.obx((state) {
          final configs = state!;
          return ListView.builder(
              itemBuilder: (context, index) {
                final config = configs[index];
                final subTitle =
                    getServiceTypeSubTitle(serviceType: config.serviceType);
                return Container(
                  margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    margin: const EdgeInsets.fromLTRB(10.0, 6.0, 10.0, 0.0),
                    child: ListTile(
                      onTap: () async {
                        await controller.changeCurrentConfig(configs[index].id);
                        Get.delete<FileController>();
                        controller.path.value = "/";
                        goToFile();
                      },
                      leading: Icon(serviceToIcon[configs[index].serviceType]),
                      tileColor:
                          config.current == 1 ? Colors.blue : Colors.grey,
                      title: Text(
                        config.name,
                        style:
                            const TextStyle(fontSize: 20, color: Colors.black),
                      ),
                      subtitle: Text(subTitle),
                      trailing: PullDownButton(
                        buttonBuilder: (context, showMenu) => CupertinoButton(
                          onPressed: showMenu,
                          padding: EdgeInsets.zero,
                          child: const Icon(
                            CupertinoIcons.ellipsis,
                            color: CupertinoColors.black,
                          ),
                        ),
                        itemBuilder: (context) => [
                          PullDownMenuItem(
                            title: 'Edit',
                            onTap: () {
                              Navigator.of(context)
                                  .push(CupertinoPageRoute(builder: (context) {
                                return EditSetting(
                                  configId: config.id,
                                  serviceType: config.serviceType,
                                );
                              }));
                            },
                          ),
                          PullDownMenuItem(
                            title: 'Delete',
                            onTap: () async {
                              if (config.current == 1) {
                                Get.snackbar(
                                    "Error", "Cannot delete current config");
                                return;
                              }
                              await controller.deleteConfig(config.id);
                            },
                          ),
                        ],
                      ),
                      // subtitle: ,
                    ),
                  ),
                );
              },
              itemCount: configs.length);
        }, onLoading: const Center(child: CupertinoActivityIndicator())),
      ),
    );
  }
}

enum OperationItem {
  none,
  edit,
  delete,
}

final serviceToIcon = {
  ServiceType.s3: FontAwesomeIcons.aws,
  ServiceType.azblob: FontAwesomeIcons.microsoft,
  ServiceType.azdls: FontAwesomeIcons.microsoft,
  ServiceType.cos: FontAwesomeIcons.cloud,
  ServiceType.oss: FontAwesomeIcons.cloud,
  ServiceType.gcs: FontAwesomeIcons.google,
};

String getServiceTypeSubTitle({required ServiceType serviceType}) {
  switch (serviceType) {
    case ServiceType.s3:
      return 'Amazon S3';
    case ServiceType.azblob:
      return 'Azure Blob Storage';
    case ServiceType.azdls:
      return 'Azure Data Lake Storage Gen2';
    case ServiceType.cos:
      return 'Tencent Cloud Object Storage';
    case ServiceType.oss:
      return 'Alibaba Cloud Object Storage';
    case ServiceType.gcs:
      return 'Google Cloud Storage';
    default:
      return '';
  }
}
