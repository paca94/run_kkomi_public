import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:run_kkomi/sound/sound_manager.dart';

class SoundController extends GetxController {
  static SoundController get to => Get.find<SoundController>();

  final soundManager = SoundManager();
  final _storage = GetStorage();

  @override
  onInit() {
    super.onInit();
  }
}
