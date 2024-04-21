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
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import "package:path_provider/path_provider.dart";

Future setupLogger() async {
  setupLogStream().listen((msg) {
    // This should use a logging framework in real applications
    print("${msg.logLevel} ${msg.lbl.padRight(8)}: ${msg.msg}");
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
  // var _currentIndex = 1;

  final CupertinoTabController _tabController =
      CupertinoTabController(initialIndex: 0);

  void goToCloud() {
    setState(() {
      _tabController.index = 0;
    });
  }

  void goToFile() {
    setState(() {
      _tabController.index = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => CloudController());
    Get.lazyPut(() => FileController());
    List<Widget> widgetOptions = <Widget>[
      Cloud(goToFile),
      const FileView(
        path: "/",
      ),
      Setting(goToCloud),
    ];

    // final i = ref.watch(currentIndexProvider);
    return GetCupertinoApp(
      // getPages: [
      //   GetPage(name: "/files", page: () => const File(),  transition: Transition.cupertino  )
      // ],
      home: CupertinoTabScaffold(
        tabBuilder: (context, index) {
          return CupertinoTabView(
            builder: (context) {
              return widgetOptions[index];
            },
          );
        },
        controller: _tabController,
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
      ),
    );
  }
}

class CloudController extends GetxController with StateMixin<List<Config>> {
  var selectIndex = 0.obs;

  @override
  void onInit() async {
    super.onInit();
    var data = await Config.listConfigs();
    change(data, status: RxStatus.success());
  }

  updateIndex(int index) {
    selectIndex.value = index;
  }

  addConfig(
      String name, ServiceType serviceType, Map<String, String> config) async {
    await Config.newInstance(
      name: name,
      serviceType: serviceType,
      config: config,
    );
    change(null, status: RxStatus.loading());
    var data = await Config.listConfigs();
    config.clear();
    change(data, status: RxStatus.success());
  }

  changeCurrentConfig(int id) async {
    change(null, status: RxStatus.loading());
    await Config.changeCurrentConfig(id: id);
    var data = await Config.listConfigs();
    change(data, status: RxStatus.success());
    final fileController = Get.find<FileController>();
    fileController.listFile("/");
    fileController.change(null, status: RxStatus.loading());
  }
}

class FileController extends GetxController with StateMixin<List<Entry>> {
  var path = "/".obs;

  // @override
  // void onInit() async {
  //   super.onInit();
  //   await listFile();
  // }
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

String getErrorDetail(Object error) {
  final s = error.toString();
  return s.substring(16, s.length - 1);
}