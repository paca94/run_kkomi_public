import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/foundation.dart';
import 'package:run_kkomi/game/kkomi_game.dart';
import 'package:run_kkomi/game/land/land.dart';

import 'items/item.dart';

enum PlayerState { jumping, running }

class Player extends SpriteAnimationGroupComponent<PlayerState>
    with HasGameRef<KKomiGame>, CollisionCallbacks {
  Player() : super(size: Vector2(60, 80));

  // 15 27

  final double gravity = 0.18;

  final double initialJumpVelocity = -5.0;
  final double introDuration = 1500.0;
  final double startXPosition = 50;
  late final int _jumpCountMax;

  double _jumpVelocity = 0.0;
  int _jumpCount = 0;

  late double _groundYPos = gameRef.size.y + 200;

  set groundYPos(value) {
    _groundYPos = value - height;
  }

  get groundYPos => _groundYPos;

  bool jumpBlock = false;
  double _flyingTime = 0;

  @override
  Future<void> onLoad() async {
    _jumpCountMax = gameRef.currentCharacterInfo.idx == 0 ? 3 : 2;
    // Body hitbox
    add(
      RectangleHitbox.relative(
        Vector2(0.9, 1),
        position: Vector2(7, 0),
        parentSize: size,
      ),
    );

    final leftRunAnimation = SpriteSheet(
      image: gameRef.spriteImageOfKkomiLeft,
      srcSize: Vector2(40, 60),
    ).createAnimation(stepTime: 0.05, row: 0);

    final leftJumpAnimation = SpriteSheet(
      image: gameRef.spriteImageOfKkomiJump,
      srcSize: Vector2(40, 60),
    ).createAnimation(stepTime: 0.05, row: 0, loop: true);

    animations = {
      PlayerState.running: leftRunAnimation,
      PlayerState.jumping: leftJumpAnimation,
    };

    current = PlayerState.jumping;
    if (gameRef.size.x < 500) {
      x = 50;
    } else {
      x = 100;
    }
    y = 100;
  }

  void jump(double speed) {
    if (current == PlayerState.jumping &&
        _jumpCount == (kDebugMode ? 10000 : _jumpCountMax)) {
      return;
    }

    if (current == PlayerState.jumping) {
      _jumpVelocity = initialJumpVelocity - (speed / 500);
    } else {
      current = PlayerState.jumping;
      _jumpVelocity += initialJumpVelocity - (speed / 500);
    }
    groundYPos = gameRef.size.y + 200;
    _jumpCount++;
    gameRef.soundManager.jump.play();
  }

  void restart() {
    current = PlayerState.jumping;
    y = 100;
    current = PlayerState.jumping;
    _jumpVelocity = 0.0;
    _jumpCount = 0;
    _flyingTime = 0.0;
  }

  void reset() {
    y = _groundYPos;
    _jumpCount = 0;
    _jumpVelocity = 0.0;
    current = PlayerState.running;
    _flyingTime = 0.0;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (gameRef.isPause) {
      return;
    }

    if (gameRef.currentCharacterInfo.idx == 1 &&
        current == PlayerState.jumping &&
        gameRef.isTap &&
        gameRef.tapTime > 0.2 &&
        _flyingTime < gameRef.currentCharacterInfo.specialValue) {
      if (_jumpVelocity < 0) {
        _jumpVelocity += -0.02;
      } else {
        _jumpVelocity = -0.1;
      }
      y += _jumpVelocity;

      _flyingTime += dt;
      gameRef.jumpBlock = true;
      return;
    }

    if (current == PlayerState.jumping) {
      y += _jumpVelocity;
      // _jumpVelocity += gravity / (0.016666 / dt);
      // _jumpVelocity += gravity / (0.00888 / dt);
      _jumpVelocity += gravity / (0.012773 / dt);
      if (_jumpVelocity >= 0 &&
          y > _groundYPos &&
          gameRef.footHitBox.isCollision) {
        reset();
      }
    }

    if (gameRef.isIntro && x < startXPosition) {
      x += (startXPosition / introDuration) * dt * 5000;
    }

    if (y + height > gameRef.size.y + 50) {
      if (gameRef.state != GameState.gameOver) {
        gameRef.gameOver();
      }
    }
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Item) {
      other.onEat();
    }
  }
}

class PlayerFootHitBox extends PositionComponent
    with HasGameRef<KKomiGame>, CollisionCallbacks {
  PlayerFootHitBox(this.parentSize) : super();

  final Vector2 parentSize;
  late final player = gameRef.player;

  int _colliderLandSize = 0;

  bool isCollision = false;

  @override
  Future<void> onLoad() async {
    size = Vector2(parentSize.x - 30, 10);
    add(RectangleHitbox.relative(Vector2(1, 1), parentSize: size));
  }

  @override
  void update(double dt) {
    super.update(dt);
    x = player.x + 23;
    y = player.y + player.height - 5;

    isCollision = _colliderLandSize != 0;

    if (_colliderLandSize == 0 && player.current == PlayerState.running) {
      player.groundYPos = gameRef.size.y + 200;
      player._jumpVelocity = 1;
      player.current = PlayerState.jumping;
    }
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is Land) {
      player.groundYPos = other.y;
      _colliderLandSize++;
    }
  }

  @override
  void onCollisionEnd(
    PositionComponent other,
  ) {
    if (other is Land) {
      _colliderLandSize--;
    }
  }
}
