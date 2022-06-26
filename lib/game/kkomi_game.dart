import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:run_kkomi/controller/sound_controller.dart';
import 'package:run_kkomi/data/consts.dart';
import 'package:run_kkomi/game/background/background_manager.dart';
import 'package:run_kkomi/game/items/item_manager.dart';
import 'package:run_kkomi/game/land/land_manager.dart';
import 'package:run_kkomi/game/player.dart';
import 'package:run_kkomi/routes/app_pages.dart';
import 'package:run_kkomi/select_main/select_controller.dart';

import 'game_over.dart';
import 'items/item.dart';

enum GameState { playing, intro, gameOver, pause }

class KKomiGame extends FlameGame
    with KeyboardEvents, TapDetector, HasCollisionDetection {
  @override
  bool debugMode = kDebugMode;

  late final Image spriteImage;
  late final Image spriteImageOfKkomiLeft;
  late final Image spriteImageOfKkomiJump;
  late final Image spriteImageOfItem;
  late final Image spriteImageOfBackground;
  late final Image spriteImageOfLand;

  @override
  Color backgroundColor() => const Color(0xFFFFFFFF);

  late final player = Player();
  late final footHitBox = PlayerFootHitBox(player.size);
  late final landManager = LandManager();
  late final gameOverPanel = GameOverPanel();
  late final ItemManager itemManager = ItemManager();
  late final soundManager = SoundController.to.soundManager;
  late final backgroundManager = BackgroundManager();
  late final TextComponent scoreText;
  late final CharacterInfo currentCharacterInfo =
      Consts.characterInfoList[SelectController.to.selectedUnit];

  final eatItems = <int, int>{};

  late int _score;
  bool _isFirstTap = false;

  int get score => _score;

  bool isTap = false;
  bool jumpBlock = false;
  double tapTime = 0.0;

  set score(int newScore) {
    _score = newScore;
    scoreText.text = 'Items:$score';
  }

  @override
  Future<void> onLoad() async {
    spriteImage = await Flame.images.load('trex.png');
    spriteImageOfItem = await Flame.images.load(Consts.spritePath.item);
    spriteImageOfBackground =
        await Flame.images.load(Consts.spritePath.background);
    spriteImageOfLand = await Flame.images.load(Consts.spritePath.land);

    spriteImageOfKkomiLeft =
        await Flame.images.load(currentCharacterInfo.spriteImageLeftPath);
    spriteImageOfKkomiJump =
        await Flame.images.load(currentCharacterInfo.spriteImageJumpPath);

    add(backgroundManager);
    add(landManager);
    add(itemManager);
    add(footHitBox);
    add(player);
    add(gameOverPanel);

    final textStyle = GoogleFonts.pressStart2p(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.grey.shade700,
    );
    final textPaint = TextPaint(style: textStyle);
    add(
      scoreText = TextComponent(
        position: Vector2(20, 20),
        textRenderer: textPaint,
      )..positionType = PositionType.viewport,
    );
    score = 0;
    currentSpeed = startSpeed;

    soundManager.background.play();
    if (true) {
      final _regularTextStyle =
          TextStyle(fontSize: 18, color: BasicPalette.black.color);
      final _regular = TextPaint(style: _regularTextStyle);
      add(FpsTextComponent(
          position: Vector2(size.x - 100, 20), textRenderer: _regular));
    }
  }

  GameState state = GameState.playing;
  double currentSpeed = 0;
  double timePlaying = 0.0;

  int level = 0;

  final double acceleration = 10;
  final double maxSpeed = 400;
  final double startSpeed = 300;

  bool get isPlaying => state == GameState.playing;

  bool get isGameOver => state == GameState.gameOver;

  bool get isIntro => state == GameState.intro;

  bool get isPause => state == GameState.pause;

  @override
  KeyEventResult onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    if (keysPressed.contains(LogicalKeyboardKey.enter) ||
        keysPressed.contains(LogicalKeyboardKey.space)) {
      onAction();
    }

    if (keysPressed.contains(const LogicalKeyboardKey(0x00000070))) {
      if (overlays.isActive('pause')) {
        overlays.remove('pause');
      } else {
        overlays.add('pause');
      }
      onPauseChanged();
    }

    if (keysPressed.contains(LogicalKeyboardKey.escape)) {
      soundManager.background.stop();
      Get.offAndToNamed(Routes.LOBBY);
    }
    return KeyEventResult.handled;
  }

  @override
  void onTapUp(TapUpInfo info) {
    onAction();
    if (_isFirstTap) {
      _isFirstTap = false;
      soundManager.background.play();
    }
    isTap = false;
    tapTime = 0;
  }

  @override
  void onTapDown(TapDownInfo info) {
    tapTime = 0;
    isTap = true;
  }

  void onAction() {
    if (isGameOver) {
      return;
    }
    if (isPause) {
      return;
    }
    if(jumpBlock) {
      jumpBlock = false;
      return;
    }
    player.jump(currentSpeed);
  }

  void addScore(Item item) {
    score++;
    if (eatItems[item.spriteIdx] == null) {
      eatItems[item.spriteIdx] = 0;
    }
    eatItems[item.spriteIdx] = eatItems[item.spriteIdx]! + 1;
  }

  void gameOver() {
    overlays.add('game_over');
    gameOverPanel.visible = true;
    state = GameState.gameOver;
    currentSpeed = 0.0;
    soundManager.background.stop();
  }

  void restart() {
    overlays.remove('game_over');
    player.restart();
    landManager.restart();
    itemManager.reset();
    currentSpeed = startSpeed;
    gameOverPanel.visible = false;
    timePlaying = 0.0;
    score = 0;
    state = GameState.playing;
    soundManager.background.play();
  }

  void onPauseChanged() {
    if (overlays.isActive('pause')) {
      state = GameState.pause;
      soundManager.background.pause();
      pauseEngine();
    } else {
      state = GameState.playing;
      soundManager.background.play();
      resumeEngine();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isGameOver) {
      return;
    }

    if (isTap) {
      tapTime += dt;
    }

    if (isPlaying) {
      timePlaying += dt;

      if (currentSpeed < maxSpeed) {
        currentSpeed += acceleration * dt;
      }
    }
  }
}
