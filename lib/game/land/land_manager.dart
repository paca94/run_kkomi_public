import 'dart:collection';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';
import 'package:run_kkomi/game/kkomi_game.dart';

import 'land.dart';

class LandManager extends PositionComponent with HasGameRef<KKomiGame> {
  LandManager() : super();

  static const int maxItemDuplication = 2;
  final _random = Random(kDebugMode ? 100 : null);
  final LandPool _landPool = LandPool();

  final Vector2 blockSize = Vector2(48, 48);
  late final double minY = blockSize.y * 3;
  late final double maxY = gameRef.size.y - blockSize.y;

  int _itemNotGenerateCount = 20;
  int _weight = 3;

  double _lastX = 0;
  double _lastY = 0;

  bool _isGenerateProcess = false;
  bool _isFirstGenerated = true;

  @override
  Future<void> onLoad() async {
    add(_landPool);
    _platformShapeGenerate(Vector2(0, 0), isFirst: true);
    _isFirstGenerated = true;
  }

  @override
  void update(double dt) {
    final lands = children.query<Land>();
    final increment = gameRef.currentSpeed * dt;
    List allocatedLands = [];
    for (final Land land in _landPool.allocatedPools) {
      if (!lands.contains(land)) {
        land.x -= increment;
        if (land.x < gameRef.size.x + 300) {
          add(land);
          allocatedLands.add(land);
          _lastX = land.x;
          _lastY = land.y;
          if (_itemNotGenerateCount < 0) {
            gameRef.itemManager
                .addNewItemAtPosition(Vector2(land.x, land.y - blockSize.y));
          } else {
            _itemNotGenerateCount--;
          }
          // add item at top of land
          continue;
        }
      }
    }
    for (final land in allocatedLands) {
      _landPool.allocatedPools.remove(land);
    }

    if (_landPool.allocatedPools.length < 6 &&
        _isFirstGenerated &&
        !_isGenerateProcess) {
      _isGenerateProcess = true;
      Future.delayed(Duration.zero, () {
        late final Land targetLand;
        if (_landPool.allocatedPools.isEmpty) {
          targetLand = _landPool.lastChild()!;
        } else {
          targetLand = _landPool.allocatedPools.last;
        }
        _generateLand(Vector2(targetLand.x + blockSize.x, _lastY));
        _isGenerateProcess = false;
      });
    }
  }

  void restart() {
    reset();
    _platformShapeGenerate(Vector2(0, 0), isFirst: true);
    _isFirstGenerated = true;
  }

  void reset() {
    _itemNotGenerateCount = 20;
    for (Land land in children.query<Land>()) {
      land.removeFromParent();
      land.onWithdraw(land);
    }
    _landPool.reset();
  }

  Vector2 _asSpritePosition(Vector2 startPosition, int posY, int poX) {
    return Vector2(startPosition.x + poX * blockSize.x,
        startPosition.y + posY * blockSize.y);
  }

  void _generateLand(Vector2 beforeLandPosition) {
    int xRand = _random.nextInt(3) + 2;
    int yRand = _random.nextInt(3);
    yRand = _random.nextInt(10) - 5 - _weight >= 0 ? yRand : -1 * yRand;
    bool isCorrection = false;
    double nextY = beforeLandPosition.y + yRand * blockSize.y;
    if (nextY < minY) {
      nextY = minY;
      isCorrection = true;
      _weight += -3;
    }

    if (nextY > maxY) {
      nextY = maxY;
      isCorrection = true;
      _weight += 3;
    }
    if (!isCorrection) {
      if (yRand != 0) {
        if (yRand > 0) {
          _weight++;
        } else {
          _weight--;
        }
      }
    }

    Vector2 startPosition =
        Vector2(beforeLandPosition.x + xRand * blockSize.x, nextY);
    _platformShapeGenerate(startPosition);
  }

  List<List<Land>> _platformShapeGenerate(Vector2 startPosition,
      {bool isFirst = false, int platformWidth = -1, int platformHeight = -1}) {
    if (isFirst) {
      platformWidth = 40;
      platformHeight = 1;
      startPosition = Vector2(1, gameRef.size.y - platformHeight * blockSize.y);
    } else {
      if (platformWidth == -1) {
        platformWidth = _random.nextInt(10) + 1;
      }
      if (platformHeight == -1) {
        platformHeight = 1;
      }
    }
    platformHeight = 1;

    late final List<List<Land>> platforms =
        List.generate(platformHeight, (platformY) {
      return List.generate(platformWidth, (platformX) {
        // first line
        if (platformY == 0) {
          if (platformX == 0) {
            // left
            return _landPool.getLand(
                0, _asSpritePosition(startPosition, platformY, platformX));
          }
          if (platformX == platformWidth - 1) {
            // right
            return _landPool.getLand(
                2, _asSpritePosition(startPosition, platformY, platformX));
          }
          return _landPool.getLand(
              1, _asSpritePosition(startPosition, platformY, platformX));
        } else if (platformY == platformHeight - 1) {
          // last line
          if (platformX == 0) {
            // left

            return _landPool.getLand(
                6, _asSpritePosition(startPosition, platformY, platformX));
          }
          if (platformX == platformWidth - 1) {
            // right

            return _landPool.getLand(
                8, _asSpritePosition(startPosition, platformY, platformX));
          }

          return _landPool.getLand(
              7, _asSpritePosition(startPosition, platformY, platformX));
        } else {
          // others
          if (platformX == 0) {
            // left

            return _landPool.getLand(
                3, _asSpritePosition(startPosition, platformY, platformX));
          }
          if (platformX == platformWidth - 1) {
            // right

            return _landPool.getLand(
                5, _asSpritePosition(startPosition, platformY, platformX));
          }
          return _landPool.getLand(
              4, _asSpritePosition(startPosition, platformY, platformX));
        }
      });
    }, growable: false);
    _landPool.allocatedPools.addAll(platforms.expand((i) => i).toList());
    return platforms;
  }
}

class LandPool extends Component with HasGameRef<KKomiGame> {
  final Map<int, List<Land>> _pool = {};
  final ListQueue<Land> allocatedPools = ListQueue();

  @override
  Future<void> onLoad() async {
    const int spriteSize = 9;
    const int initSize = 20;
    for (int spriteIdx = 0; spriteIdx < spriteSize; spriteIdx++) {
      _pool[spriteIdx] = List.generate(
        initSize,
        (index) => _newLand(spriteIdx),
      );
    }
  }

  reset() {
    for (Land land in allocatedPools) {
      land.removeFromParent();
      _pool[land.spriteIdx]!.add(land);
    }
    allocatedPools.clear();
  }

  withdraw(Land currentLand) {
    _pool[currentLand.spriteIdx]!.add(currentLand);
  }

  _newLand(int spriteIdx) {
    return Land(
      spriteIdx: spriteIdx,
      onWithdraw: withdraw,
    );
  }

  getLand(int spriteIdx, Vector2 position) {
    late final Land land;
    if (_pool[spriteIdx]!.isEmpty) {
      land = _newLand(spriteIdx);
    } else {
      land = _pool[spriteIdx]!.removeLast();
    }
    land.onAssigned(position);
    return land;
  }
}
