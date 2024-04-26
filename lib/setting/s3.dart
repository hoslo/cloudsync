import 'package:cloudsync/main.dart';
import 'package:cloudsync/src/rust/api/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class S3Setting extends StatelessWidget {
  const S3Setting({
    super.key,
    this.id,
  });

  final int? id;

  Future<bool> createConfig(
    String name,
    String accessKeyId,
    String secretAccessKey,
    String bucket,
    String endpoint,
    String region,
    String root,
  ) async {
    if (name.isEmpty ||
        accessKeyId.isEmpty ||
        secretAccessKey.isEmpty ||
        bucket.isEmpty ||
        endpoint.isEmpty ||
        region.isEmpty ||
        root.isEmpty) {
      Get.snackbar("Error", "Please fill all fields");
      return false;
    }
    final controller = Get.find<CloudController>();
    await controller.createConfig(name, ServiceType.s3, {
      "access_key_id": accessKeyId,
      "secret_access_key": secretAccessKey,
      "bucket": bucket,
      "endpoint": endpoint,
      "region": region,
      "root": root
    });
    return true;
  }

  Future<bool> updateConfig(
    int current,
    String name,
    String accessKeyId,
    String secretAccessKey,
    String bucket,
    String endpoint,
    String region,
    String root,
  ) async {
    if (name.isEmpty ||
        accessKeyId.isEmpty ||
        secretAccessKey.isEmpty ||
        bucket.isEmpty ||
        endpoint.isEmpty ||
        region.isEmpty ||
        root.isEmpty) {
      Get.snackbar("Error", "Please fill all fields");
      return false;
    }
    final controller = Get.find<CloudController>();
    await controller.updateConfig(id!, name, current, {
      "access_key_id": accessKeyId,
      "secret_access_key": secretAccessKey,
      "bucket": bucket,
      "endpoint": endpoint,
      "region": region,
      "root": root
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController regionController =
        TextEditingController(text: "auto");
    TextEditingController nameController = TextEditingController();
    TextEditingController accessKeyIdController = TextEditingController();
    TextEditingController secretAccessKeyController = TextEditingController();
    TextEditingController bucketController = TextEditingController();
    TextEditingController endpointController = TextEditingController();
    TextEditingController rootController = TextEditingController(text: "/");
    var current = 0;
    if (id != null) {
      Config.getConfig(id: id!).then((value) => {
            nameController.text = value.name,
            accessKeyIdController.text = value.config["access_key_id"]!,
            secretAccessKeyController.text = value.config["secret_access_key"]!,
            bucketController.text = value.config["bucket"]!,
            endpointController.text = value.config["endpoint"]!,
            regionController.text = value.config["region"]!,
            rootController.text = value.config["root"]!,
            current = value.current
          });
    }

    return CupertinoFormSection.insetGrouped(
      children: [
        CupertinoTextFormFieldRow(
            prefix: const Text("Name"), controller: nameController),
        CupertinoTextFormFieldRow(
            prefix: const Text("Access Key ID"),
            controller: accessKeyIdController),
        CupertinoTextFormFieldRow(
            prefix: const Text("Secret Access Key"),
            controller: secretAccessKeyController),
        CupertinoTextFormFieldRow(
            prefix: const Text("Bucket"), controller: bucketController),
        CupertinoTextFormFieldRow(
            prefix: const Text("Endpoint"), controller: endpointController),
        CupertinoTextFormFieldRow(
            prefix: const Text("Region"), controller: regionController),
        CupertinoTextFormFieldRow(
            prefix: const Text("Root"), controller: rootController),
        CupertinoButton(
          child: const Text("Save"),
          onPressed: () async {
            var result = false;
            if (id != null) {
              result = await updateConfig(
                current,
                nameController.text,
                accessKeyIdController.text,
                secretAccessKeyController.text,
                bucketController.text,
                endpointController.text,
                regionController.text,
                rootController.text,
              );
            } else {
              result = await createConfig(
                nameController.text,
                accessKeyIdController.text,
                secretAccessKeyController.text,
                bucketController.text,
                endpointController.text,
                regionController.text,
                rootController.text,
              );
            }
            if (result) {
              accessKeyIdController.clear();
              secretAccessKeyController.clear();
              bucketController.clear();
              endpointController.clear();
              regionController.clear();
              rootController.clear();
              nameController.clear();
            } else {
              return;
            }
            if (id == null) {
              final tabController = Get.find<MainController>();
              tabController.currentIndex.value.index = 0;
            } else {
              // ignore: use_build_context_synchronously
              Navigator.pop(context);
            }
          },
        ),
      ],
    );
  }
}
