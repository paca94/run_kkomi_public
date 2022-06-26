import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:run_kkomi/common/custom_text_button.dart';
import 'package:run_kkomi/game/kkomi_controller.dart';
import 'package:run_kkomi/game/kkomi_game.dart';

import '../common/common_scaffold.dart';

class KkomiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => KkomiGameController());
  }
}

class KkomiScreen extends GetView<KkomiGameController> {
  const KkomiScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final kkomiGame = KKomiGame();
    final size = MediaQuery.of(context).size;
    final width = size.width > 800.0 ? 800.0 : size.width;
    final height = size.height > 800.0 ? 800.0 : size.height;
    return CommonScaffold(
      child: Center(
        child: Container(
          width: width,
          height: height,
          color: Colors.black87,
          padding: const EdgeInsets.all(8),
          child: ClipRect(
            child: GameWidget(
              game: kkomiGame,
              loadingBuilder: (_) => const Center(
                child: Text('Loading'),
              ),
              overlayBuilderMap: {
                'pause': (ctx, game) {
                  return const Center(
                    child: Text(
                      'pause',
                      style: TextStyle(fontFamily: 'dalmoori', fontSize: 80),
                    ),
                  );
                },
                'game_over': (ctx, game) {
                  return Center(
                    child: FittedBox(
                      child: Column(
                        children: [
                          CustomTextButton(
                            text: '다시 시작',
                            fontSize: 30,
                            onTap: () {
                              kkomiGame.restart();
                            },
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          CustomTextButton(
                            text: '메인으로',
                            fontSize: 32,
                            onTap: () {
                              Get.back();
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              },
            ),
          ),
        ),
      ),
    );
  }
}
