import 'dart:ui';

import 'package:flame/components.dart';
import 'package:run_kkomi/game/kkomi_game.dart';

class GameOverPanel extends Component {
  bool visible = false;

  @override
  Future<void> onLoad() async {
    add(GameOverText());
  }

  @override
  void renderTree(Canvas canvas) {
    if (visible) {
      super.renderTree(canvas);
    }
  }
}

class GameOverText extends SpriteComponent with HasGameRef<KKomiGame> {
  GameOverText() : super(size: Vector2(382, 25), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    sprite = Sprite(
      gameRef.spriteImage,
      srcPosition: Vector2(955.0, 26.0),
      srcSize: size,
    );
  }

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
    x = gameSize.x / 2;
    y = gameSize.y * .25;
  }
}
