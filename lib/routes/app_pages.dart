import 'package:get/get.dart';
import 'package:run_kkomi/game/kkomi_screen.dart';
import 'package:run_kkomi/lobby/lobby_screen.dart';
import 'package:run_kkomi/select_main/select_binding.dart';

import '../select_main/select_screen.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOBBY;

  static final routes = [
    GetPage(
      name: _Paths.LOBBY,
      page: () => LobbyScreen(),
    ),
    GetPage(
      name: _Paths.CHARACTER_SELECT,
      page: () => SelectScreen(),
      binding: SelectBinding(),
    ),
    GetPage(
      name: _Paths.GAME,
      page: () => KkomiScreen(),
      binding: KkomiBinding(),
    ),
  ];
}
