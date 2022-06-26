import 'dart:math';

import 'package:run_kkomi/data/consts.dart';
import 'package:run_kkomi/game/kkomi_game.dart';
import 'package:flame/components.dart';

class BackgroundManager extends PositionComponent with HasGameRef<KKomiGame> {
  final double cloudFrequency = 0.5;
  final int maxClouds = 20;
  final double bgCloudSpeed = 0.2;

  final Random _random = Random();

  double get cloudSpeed => bgCloudSpeed / 1000 * gameRef.currentSpeed;

  late final List<SpriteComponent> clouds;
  late final _trainBaseY;

  @override
  Future<void> onLoad() async {
    final backgroundSprite = gameRef.spriteImageOfBackground;
    add(
      SpriteComponent(
        sprite: Sprite(
          backgroundSprite,
          srcSize: Consts.spriteBackgroundInfo.daytimeBackground.size,
          srcPosition: Consts.spriteBackgroundInfo.daytimeBackground.position,
        ),
        size: gameRef.size,
        position: Vector2(0, 0),
      ),
    );
    Vector2 newSize =
        asSize(Consts.spriteBackgroundInfo.daytimeMovableBackground1.size);
    add(
      SpriteComponent(
        sprite: Sprite(
          backgroundSprite,
          srcSize: Consts.spriteBackgroundInfo.daytimeMovableBackground1.size,
          srcPosition:
              Consts.spriteBackgroundInfo.daytimeMovableBackground1.position,
        ),
        size: newSize,
        position: Vector2(0, gameRef.size.y - newSize.y),
      ),
    );
    newSize =
        asSize(Consts.spriteBackgroundInfo.daytimeMovableBackground2.size);
    add(
      SpriteComponent(
        sprite: Sprite(
          backgroundSprite,
          srcSize: Consts.spriteBackgroundInfo.daytimeMovableBackground2.size,
          srcPosition:
              Consts.spriteBackgroundInfo.daytimeMovableBackground2.position,
        ),
        size: newSize,
        position: Vector2(0, gameRef.size.y - newSize.y),
      ),
    );

    newSize = asSize(Consts.spriteBackgroundInfo.daytimeBridge.size);
    add(
      SpriteComponent(
        sprite: Sprite(
          backgroundSprite,
          srcSize: Consts.spriteBackgroundInfo.daytimeBridge.size,
          srcPosition: Consts.spriteBackgroundInfo.daytimeBridge.position,
        ),
        size: newSize,
        position: Vector2(0, gameRef.size.y - newSize.y),
      ),
    );
    _trainBaseY = gameRef.size.y - newSize.y;

    addTrain();

    addCloud();
  }

  Vector2 asSize(Vector2 beforeSize) {
    beforeSize.divide(gameRef.size);
    final radio = gameRef.size.x / beforeSize.x;
    return Vector2(beforeSize.x * radio, beforeSize.y * radio);
  }

  @override
  void update(double dt) {
    super.update(dt);
    final clouds = children.query<Cloud>();
    if (clouds.isEmpty) {
      addCloud();
    }
    final trains = children.query<Cloud>();
    if (trains.isEmpty) {
      addTrain();
    }
  }

  void addCloud() {
    add(
      Cloud(
          Sprite(
            gameRef.spriteImageOfBackground,
            srcSize: Consts.spriteBackgroundInfo.daytimeCloud.size,
            srcPosition: Consts.spriteBackgroundInfo.daytimeCloud.position,
          ),
          size = Consts.spriteBackgroundInfo.daytimeCloud.size * 1.2),
    );
  }

  void addTrain() {
    add(
      Train(
        Sprite(
          gameRef.spriteImageOfBackground,
          srcSize: Consts.spriteBackgroundInfo.daytimeTrain.size,
          srcPosition: Consts.spriteBackgroundInfo.daytimeTrain.position,
        ),
        size = Consts.spriteBackgroundInfo.daytimeTrain.size * 1.2,
        Vector2(gameRef.size.x + 100, _trainBaseY),
        100.0 + _random.nextInt(200),
      ),
    );
  }
}

class Cloud extends SpriteComponent with HasGameRef<KKomiGame> {
  Cloud(sprite, size) : super(sprite: sprite, size: size);
  final _random = Random();

  @override
  Future<void> onLoad() async {
    position = Vector2(gameRef.size.x, _random.nextDouble() * 200 + 40);
  }

  @override
  void update(double dt) {
    super.update(dt);
    x -= dt * 100;
    if (x < -size.x - 100) {
      removeFromParent();
    }
  }
}

class Train extends SpriteComponent with HasGameRef<KKomiGame> {
  late final double speed;

  Train(sprite, size, position, this.speed)
      : super(sprite: sprite, size: size, position: position);

  @override
  Future<void> onLoad() async {
    position.y -= size.y;
  }

  @override
  void update(double dt) {
    super.update(dt);
    x -= dt * speed;
    if (x < -size.x - 100) {
      removeFromParent();
    }
  }
}
