import 'package:cloudsync/file.dart';
import 'package:cloudsync/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Cloud extends GetView<CloudController> {
  const Cloud(this.goToCloud, {super.key});

  final VoidCallback goToCloud;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: controller.obx((state) {
          final configs = state!;
          return ListView.separated(
              itemBuilder: (context, index) {
                print("config: ${configs[index].config}");
                return ListTile(
                  onTap: () async {
                    await controller.changeCurrentConfig(configs[index].id);
                    goToCloud();
                    // Navigator.of(context)
                    //     .push(CupertinoPageRoute(builder: (context) {
                    //   return FileView(
                    //     path: "/",
                    //   );
                    // }));
                  },
                  tileColor:
                      configs[index].current == 1 ? Colors.blue : Colors.grey,
                  title: Text(
                    configs[index].name,
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
              itemCount: configs.length);
        }, onLoading: const Center(child: CupertinoActivityIndicator())),
      ),
    );
  }
}
