import 'package:get/get.dart';

class KkomiGameController extends GetxController {
  static KkomiGameController get to => Get.find<KkomiGameController>();
  final _obj = ''.obs;

  set obj(value) => _obj.value = value;

  get obj => _obj.value;
}
