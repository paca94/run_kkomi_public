import 'package:get/get.dart';

class SelectController extends GetxController {
  static get to => Get.find<SelectController>();

  final _selectedUnit = (-1).obs;

  set selectedUnit(int value) => _selectedUnit.value = value;

  int get selectedUnit => _selectedUnit.value;
}
