import 'package:cloudsync/main.dart';
import 'package:cloudsync/src/rust/api/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class S3Setting extends StatelessWidget {
  const S3Setting({super.key, required this.goToCloud});

  final VoidCallback goToCloud;

  @override
  Widget build(BuildContext context) {
    TextEditingController regionController = TextEditingController();
    TextEditingController accessKeyIdController = TextEditingController();
    TextEditingController secretAccessKeyController = TextEditingController();
    TextEditingController bucketController = TextEditingController();
    TextEditingController endpointController = TextEditingController();
    final controller = Get.find<CloudController>();
    return CupertinoFormSection(
      footer: CupertinoButton(
          child: const Text('Save'),
          onPressed: () async {
            await controller.addConfig("S3-1", ServiceType.s3, {
              "access_key_id": accessKeyIdController.text,
              "secret_access_key": secretAccessKeyController.text,
              "bucket": bucketController.text,
              "endpoint": endpointController.text,
              "region": regionController.text,
            });

            accessKeyIdController.clear();
            secretAccessKeyController.clear();
            bucketController.clear();
            endpointController.clear();
            regionController.clear();

            goToCloud();
          }),
      children: [
        CupertinoTextFormFieldRow(
          prefix: const Text('access_key_id'),
        ),
        const SizedBox(height: 20),
        CupertinoTextFormFieldRow(
          prefix: const Text('secret_access_key'),
        ),
        const SizedBox(height: 20),
        CupertinoTextFormFieldRow(
          prefix: const Text('bucket'),
        ),
        const SizedBox(height: 20),
        CupertinoTextFormFieldRow(
          prefix: const Text('endpoint'),
        ),
        const SizedBox(height: 20),
        CupertinoTextFormFieldRow(
          controller: regionController,
          prefix: const Text('region'),
        )
      ],
    );
  }
}
