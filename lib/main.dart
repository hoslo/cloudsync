import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:cloudsync/file.dart';
import 'package:cloudsync/cloud.dart';
import 'package:cloudsync/setting.dart';
import 'package:cloudsync/src/rust/api/cloud_service.dart';
import 'package:cloudsync/src/rust/api/config.dart';
import 'package:cloudsync/src/rust/api/data.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloudsync/src/rust/frb_generated.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import "package:path_provider/path_provider.dart";

Future setupLogger() async {
  setupLogStream().listen((msg) {
    // This should use a logging framework in real applications
    print("${msg.logLevel} ${msg.lbl}: ${msg.msg}");
  });
}

Future<void> main() async {
  await RustLib.init();
  WidgetsFlutterBinding.ensureInitialized();
  await setupLogger();
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    print(details.exception);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    print(error);
    return true;
  };
  final dir = await getApplicationDocumentsDirectory();
  await newDatabase(dbUrl: '${dir.path}/cloudysync.db?mode=rwc');

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => CloudController());
    Get.lazyPut(() => FileController());
    Get.lazyPut(() => MainController());
    final keyList = List.generate(3, (index) {
      return GlobalKey<NavigatorState>();
    });
    List<Widget> widgetOptions = <Widget>[
      Cloud(navigateKey: keyList[1]),
      const FileView(),
      const Setting(),
    ];
    final tabController = Get.find<MainController>();

    // final i = ref.watch(currentIndexProvider);
    return GetCupertinoApp(
      debugShowCheckedModeBanner: false,
      theme: const CupertinoThemeData(
        scaffoldBackgroundColor: CupertinoColors.systemGroupedBackground,
      ),
      home: Obx(() => CupertinoTabScaffold(
            tabBuilder: (context, index) {
              return CupertinoTabView(
                navigatorKey: keyList[index],
                builder: (context) {
                  return widgetOptions[index];
                },
              );
            },
            controller: tabController.currentIndex.value,
            resizeToAvoidBottomInset: false,
            tabBar: CupertinoTabBar(
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.folder),
                  label: 'Clouds',
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.cloud),
                  label: 'Files',
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.settings),
                  label: 'Settings',
                ),
              ],
            ),
          )),
    );
  }
}

class CloudController extends GetxController with StateMixin<List<Config>> {
  var selectService = "S3".obs;
  var selectItem = OperationItem.none.obs;
  var path = "/".obs;
  var emptyRoute = false.obs;

  @override
  void onInit() async {
    super.onInit();
    var data = await Config.listConfigs();
    change(data, status: RxStatus.success());
  }

  createConfig(
      String name, ServiceType serviceType, Map<String, String> config) async {
    await Config.newInstance(
      name: name,
      serviceType: serviceType,
      config: config,
    );
    change(null, status: RxStatus.loading());
    var data = await Config.listConfigs();
    change(data, status: RxStatus.success());
  }

  deleteConfig(int id) async {
    await Config.deleteConfig(id: id);
    change(null, status: RxStatus.loading());
    var data = await Config.listConfigs();
    change(data, status: RxStatus.success());
  }

  updateConfig(
      int id, String name, int current, Map<String, String> config) async {
    await Config.updateConfig(id: id, name: name, config: config);
    if (current == 1) {
      Get.delete<FileController>();
      path.value = "/";
    }
    change(null, status: RxStatus.loading());
    var data = await Config.listConfigs();
    change(data, status: RxStatus.success());
  }

  changeCurrentConfig(int id) async {
    change(null, status: RxStatus.loading());
    await Config.changeCurrentConfig(id: id);
    var data = await Config.listConfigs();
    change(data, status: RxStatus.success());
  }
}

class FileController extends GetxController with StateMixin<List<Entry>> {
  clearCache() async {
    await CloudService.clearCache();
  }

  listFile(String path) async {
    try {
      print(555555);
      var data = await CloudService.list(path: path);
      print('data $data');
      change(data, status: RxStatus.success());
    } catch (e) {
      getErrorDetail(e);
      change(null, status: RxStatus.error(getErrorDetail(e)));
    }
  }
}

class MainController extends GetxController {
  var currentIndex = CupertinoTabController(initialIndex: 1).obs;
}

String getErrorDetail(Object error) {
  final s = error.toString();
  return s.substring(16, s.length - 1);
}
