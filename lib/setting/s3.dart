import 'package:cloudsync/main.dart';
import 'package:cloudsync/src/rust/api/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_cupertino_fields/form_builder_cupertino_fields.dart';
import 'package:get/get.dart';

class S3Setting extends StatelessWidget {
  const S3Setting({super.key, required this.goToCloud});

  final VoidCallback goToCloud;

  @override
  Widget build(BuildContext context) {
    TextEditingController regionController =
        TextEditingController(text: "auto");
    TextEditingController accessKeyIdController = TextEditingController();
    TextEditingController secretAccessKeyController = TextEditingController();
    TextEditingController bucketController = TextEditingController();
    TextEditingController endpointController = TextEditingController();
    TextEditingController rootController = TextEditingController(text: "/");
    final controller = Get.find<CloudController>();
    return CupertinoFormSection.insetGrouped(
      children: [
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
            if (accessKeyIdController.text.isEmpty ||
                secretAccessKeyController.text.isEmpty ||
                bucketController.text.isEmpty ||
                endpointController.text.isEmpty ||
                regionController.text.isEmpty ||
                rootController.text.isEmpty) {
              Get.snackbar("Error", "Please fill all fields");
              return;
            }
            await controller.addConfig("S3-1", ServiceType.s3, {
              "access_key_id": accessKeyIdController.text,
              "secret_access_key": secretAccessKeyController.text,
              "bucket": bucketController.text,
              "endpoint": endpointController.text,
              "region": regionController.text,
              "root": rootController.text
            });

            accessKeyIdController.clear();
            secretAccessKeyController.clear();
            bucketController.clear();
            endpointController.clear();
            regionController.clear();

            goToCloud();
          },
        ),
      ],
    );
  }
}
