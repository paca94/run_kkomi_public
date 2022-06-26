import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:run_kkomi/controller/sound_controller.dart';
import 'package:run_kkomi/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  final soundController = SoundController();
  Get.put(soundController);
  await soundController.soundManager.init();
  runApp(
    GetMaterialApp(
      title: 'kkomi run',
      theme: ThemeData(useMaterial3: true),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
