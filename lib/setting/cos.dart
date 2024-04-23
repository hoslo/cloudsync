import 'package:cloudsync/main.dart';
import 'package:cloudsync/src/rust/api/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class CosSetting extends StatelessWidget {
  const CosSetting({super.key, required this.goToCloud});

  final VoidCallback goToCloud;

  @override
  Widget build(BuildContext context) {
    TextEditingController secretIdController = TextEditingController();
    TextEditingController secretKeyController = TextEditingController();
    TextEditingController bucketController = TextEditingController();
    TextEditingController endpointController = TextEditingController();
    TextEditingController rootController = TextEditingController(text: "/");
    final controller = Get.find<CloudController>();
    return CupertinoFormSection.insetGrouped(
      children: [
        CupertinoTextFormFieldRow(
            prefix: const Text("Secret ID"),
            controller: secretIdController),
        CupertinoTextFormFieldRow(
            prefix: const Text("Secret Key"),
            controller: secretKeyController),
        CupertinoTextFormFieldRow(
            prefix: const Text("Bucket"), controller: bucketController),
        CupertinoTextFormFieldRow(
            prefix: const Text("Endpoint"), controller: endpointController),
        CupertinoTextFormFieldRow(
            prefix: const Text("Root"), controller: rootController),
        CupertinoButton(
          child: const Text("Save"),
          onPressed: () async {
            if (secretIdController.text.isEmpty ||
                secretKeyController.text.isEmpty ||
                bucketController.text.isEmpty ||
                endpointController.text.isEmpty ||
                rootController.text.isEmpty) {
              Get.snackbar("Error", "Please fill all fields");
              return;
            }
            await controller.addConfig("S3-1", ServiceType.s3, {
              "secret_id": secretIdController.text,
              "secret_key": secretKeyController.text,
              "bucket": bucketController.text,
              "endpoint": endpointController.text,
              "root": rootController.text
            });

            secretIdController.clear();
            secretKeyController.clear();
            bucketController.clear();
            endpointController.clear();
            rootController.clear();

            goToCloud();
          },
        ),
      ],
    );
  }
}
