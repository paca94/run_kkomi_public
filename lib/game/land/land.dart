import 'dart:collection';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:run_kkomi/data/consts.dart';
import 'package:run_kkomi/game/kkomi_game.dart';

class Land extends SpriteComponent with HasGameRef<KKomiGame> {
  Land({required this.spriteIdx, required this.onWithdraw}) : super();
  int spriteIdx;
  Function onWithdraw;

  static final Vector2 blockSize = Vector2(48, 48);
  final Queue<SpriteComponent> groundLayers = Queue();

  static final _sprites = [];

  @override
  Future<void> onLoad() async {
    if (_sprites.isEmpty) {
      _sprites.addAll([
        // top
        Sprite(
          gameRef.spriteImageOfLand,
          srcPosition: Consts.spriteLandInfo.topLeft.position,
          srcSize: Consts.spriteLandInfo.topLeft.size,
        ),
        Sprite(
          gameRef.spriteImageOfLand,
          srcPosition: Consts.spriteLandInfo.topCenter.position,
          srcSize: Consts.spriteLandInfo.topCenter.size,
        ),
        Sprite(
          gameRef.spriteImageOfLand,
          srcPosition: Consts.spriteLandInfo.topRight.position,
          srcSize: Consts.spriteLandInfo.topRight.size,
        ),
        // middle
        Sprite(
          gameRef.spriteImageOfLand,
          srcPosition: Consts.spriteLandInfo.middleLeft.position,
          srcSize: Consts.spriteLandInfo.middleLeft.size,
        ),
        Sprite(
          gameRef.spriteImageOfLand,
          srcPosition: Consts.spriteLandInfo.middleCenter.position,
          srcSize: Consts.spriteLandInfo.middleCenter.size,
        ),
        Sprite(
          gameRef.spriteImageOfLand,
          srcPosition: Consts.spriteLandInfo.middleRight.position,
          srcSize: Consts.spriteLandInfo.middleRight.size,
        ),
        // bottom
        Sprite(
          gameRef.spriteImageOfLand,
          srcPosition: Consts.spriteLandInfo.bottomLeft.position,
          srcSize: Consts.spriteLandInfo.bottomLeft.size,
        ),
        Sprite(
          gameRef.spriteImageOfLand,
          srcPosition: Consts.spriteLandInfo.bottomCenter.position,
          srcSize: Consts.spriteLandInfo.bottomCenter.size,
        ),
        Sprite(
          gameRef.spriteImageOfLand,
          srcPosition: Consts.spriteLandInfo.bottomRight.position,
          srcSize: Consts.spriteLandInfo.bottomRight.size,
        ),
      ]);
    }
    sprite = _sprites[spriteIdx];
    size = blockSize;
    add(
      LandHitBox(size),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    final increment = gameRef.currentSpeed * dt;
    x -= increment;

    if (x + width < 0) {
      removeFromParent();
      onWithdraw(this);
    }
  }

  void onAssigned(final Vector2 newPosition) {
    x = newPosition.x;
    y = newPosition.y;
  }

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
  }
}

class LandHitBox extends RectangleHitbox {
  LandHitBox(size)
      : super.relative(
          Vector2(0.95, 0.1),
          position: Vector2(0.25, 0),
          parentSize: size,
        );
  @override
  CollisionType collisionType = CollisionType.passive;
}
