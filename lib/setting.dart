import 'package:cloudsync/main.dart';
import 'package:cloudsync/setting/r2.dart';
import 'package:cloudsync/setting/s3.dart';
import 'package:cloudsync/src/rust/api/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class Setting extends StatelessWidget {
  const Setting(this.goToCloud, {super.key});

  final VoidCallback goToCloud;

  get onPressed => null;
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CloudController>();

    void _showDialog(Widget child) {
      showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
          height: 216,
          padding: const EdgeInsets.only(top: 6.0),
          // The Bottom margin is provided to align the popup above the system navigation bar.
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          // Provide a background color for the popup.
          color: CupertinoColors.systemBackground.resolveFrom(context),
          // Use a SafeArea widget to avoid system overlaps.
          child: SafeArea(
            top: false,
            child: child,
          ),
        ),
      );
    }

    final settings = {
      "S3": S3Setting(goToCloud: goToCloud,),
      "R2": R2Setting(goToCloud: goToCloud,),
    };
    print('3333 ${controller.selectIndex.value}');

    return SafeArea(
      child: CupertinoPageScaffold(
          child: Center(
        child: Column(
          children: [
            Center(
              child: CupertinoButton(
                  onPressed: () => _showDialog(
                        CupertinoPicker(
                          magnification: 1.22,
                          squeeze: 1.2,
                          useMagnifier: true,
                          itemExtent: 32.0,
                          // This sets the initial item.
                          scrollController: FixedExtentScrollController(
                            initialItem: controller.selectIndex.value,
                          ),
                          // This is called when selected item is changed.
                          onSelectedItemChanged: (int selectedItem) {
                            controller.selectIndex.value = selectedItem;
                          },
                          children: List<Widget>.generate(settings.keys.length,
                              (int index) {
                            return Center(child: Text(settings.keys.toList()[index]));
                          }),
                        ),
                      ),
                  child: Obx(
                      () => Text(settings.keys.toList()[controller.selectIndex.value]))),
            ),
            Obx(() => settings[settings.keys.toList()[controller.selectIndex.value]]!)
          ],
        ),
      )),
    );
  }
}
