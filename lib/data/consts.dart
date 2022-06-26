import 'package:flame/input.dart';

abstract class Consts {
  static const SpritePath spritePath = SpritePath();
  static const SoundPath soundPath = SoundPath();
  static const SpriteItemInfo spriteItemInfo = SpriteItemInfo();
  static const SpriteCharacterInfo spriteCharacterInfo = SpriteCharacterInfo();
  static const SpriteBackgroundInfo spriteBackgroundInfo =
      SpriteBackgroundInfo();
  static const SpriteLandInfo spriteLandInfo = SpriteLandInfo();
  static final List<CharacterInfo> characterInfoList = [
    CharacterInfo(
        idx: 0,
        name: '꼬미',
        description: '꼬미입니다. 3번 점프할 수 있습니다',
        selectorImagePath: 'assets/images/kkomi-default-stand.gif',
        onSelectorImagePath: 'assets/images/kkomi-default-on-select.gif',
        spriteImageLeftPath: 'kkomi-default-left.png',
        spriteImageJumpPath: 'kkomi-default-jump.png',
        specialValue: 1),
    CharacterInfo(
        idx: 1,
        name: '악마 꼬미',
        description: '악마 꼬미입니다. 잠시 공중에 떠있을 수 있습니다.',
        selectorImagePath: 'assets/images/kkomi-devil-stand.gif',
        onSelectorImagePath: 'assets/images/kkomi-devil-on-select.gif',
        spriteImageLeftPath: 'kkomi-devil-left.png',
        spriteImageJumpPath: 'kkomi-devil-jump.png',
        specialValue: 1),
  ];
}

class SpritePath {
  const SpritePath();

  String get kkomiDefaultJump => 'kkomi-default-jump.png';

  String get kkomiDefaultLeft => 'kkomi-default-left.png';

  String get item => 'item_words-Sheet.png';

  String get background => 'pixel_sidescroller_backgrounds_city_1.1-Sheet.png';

  String get land => 'land-Sheet.png';
}

class SoundPath {
  const SoundPath();

  String get backgroundMusic => 'assets/audio/game_background.mp3';

  String get coinSound => 'assets/audio/coin.wav';

  String get jumpSound => 'assets/audio/jump.wav';

  String get clickSound => 'assets/audio/click.wav';
}

class SpriteItemInfo {
  const SpriteItemInfo();

  Vector2 get _spriteSize => Vector2(12, 16);

  Vector2 get size => _spriteSize;

  SpriteInfo get eight => SpriteInfo(Vector2(0, 0), _spriteSize);

  SpriteInfo get h => SpriteInfo(Vector2(_spriteSize.x * 1, 0), _spriteSize);

  SpriteInfo get a => SpriteInfo(Vector2(_spriteSize.x * 2, 0), _spriteSize);

  SpriteInfo get p => SpriteInfo(Vector2(_spriteSize.x * 3, 0), _spriteSize);

  SpriteInfo get y => SpriteInfo(Vector2(_spriteSize.x * 4, 0), _spriteSize);

  SpriteInfo get b => SpriteInfo(Vector2(_spriteSize.x * 5, 0), _spriteSize);

  SpriteInfo get i => SpriteInfo(Vector2(_spriteSize.x * 6, 0), _spriteSize);

  SpriteInfo get r => SpriteInfo(Vector2(_spriteSize.x * 7, 0), _spriteSize);

  SpriteInfo get t => SpriteInfo(Vector2(_spriteSize.x * 8, 0), _spriteSize);

  SpriteInfo get d => SpriteInfo(Vector2(_spriteSize.x * 9, 0), _spriteSize);
}

class SpriteCharacterInfo {
  const SpriteCharacterInfo();

  Vector2 get _spriteSize => Vector2(19, 26);

  ///
  /// front view
  ///
  Vector2 get _sizeOfFont => _spriteSize;

  List<SpriteInfo> get frontStand {
    var results = <SpriteInfo>[];
    for (int i = 0; i < 4; i++) {
      results.add(SpriteInfo(Vector2(_spriteSize.x * i, 0), _sizeOfFont));
    }
    return results;
  }

  List<SpriteInfo> get frontOnSelect => [
        SpriteInfo(Vector2(0, 27), _sizeOfFont),
      ];

  ///
  /// left view
  ///
  Vector2 get _sizeOfLeft => Vector2(19, 27);

  List<SpriteInfo> get leftStand => [
        SpriteInfo(Vector2(0, 54), _sizeOfLeft),
      ];

  List<SpriteInfo> get leftRun {
    var results = <SpriteInfo>[];
    for (int i = 0; i < 10; i++) {
      results.add(SpriteInfo(Vector2(_spriteSize.x * i, 81), _sizeOfLeft));
    }
    return results;
  }

  List<SpriteInfo> get leftJump => [
        SpriteInfo(Vector2(0, 108), _sizeOfLeft),
        SpriteInfo(Vector2(19, 108), _sizeOfLeft),
      ];
}

class SpriteBackgroundInfo {
  const SpriteBackgroundInfo();

  SpriteInfo get daytimeBackground =>
      SpriteInfo(Vector2(0, 0), Vector2(320, 200));

  //0 200 > 320 83 // movable background
  SpriteInfo get daytimeMovableBackground1 =>
      SpriteInfo(Vector2(0, 200), Vector2(320, 83));

  //0 283 > 320 79 // movable background
  SpriteInfo get daytimeMovableBackground2 =>
      SpriteInfo(Vector2(0, 283), Vector2(320, 79));

  //0 362 >  75 101 // building
  SpriteInfo get daytimeBuilding1 =>
      SpriteInfo(Vector2(0, 362), Vector2(75, 101));

  // 463 > 70 50 // building
  SpriteInfo get daytimeBuilding2 =>
      SpriteInfo(Vector2(0, 463), Vector2(70, 50));

  // 513 > 56 61 // building
  SpriteInfo get daytimeBuilding3 =>
      SpriteInfo(Vector2(0, 513), Vector2(56, 61));

  // 574 > 62 98 // building
  SpriteInfo get daytimeBuilding4 =>
      SpriteInfo(Vector2(0, 574), Vector2(62, 98));

  // 672 > 320 18 // tree
  SpriteInfo get daytimeTree => SpriteInfo(Vector2(0, 672), Vector2(320, 18));

  // 690 > 320 27 // bridge
  SpriteInfo get daytimeBridge => SpriteInfo(Vector2(0, 690), Vector2(320, 27));

  // 717 > 320 8 // train
  SpriteInfo get daytimeTrain => SpriteInfo(Vector2(0, 717), Vector2(320, 8));

  // 725 > 301 68 // cloud
  SpriteInfo get daytimeCloud => SpriteInfo(Vector2(0, 725), Vector2(301, 68));

// parts of 저녁
// 793 > 320 200 // 저녁 background
// 993 > 320 76 // 저녁 안개?
// 1063 > 79 79 // 태양
// 1148 > 320 83 // movable background

// part of 저녁
// 1741
}

class SpriteLandInfo {
  const SpriteLandInfo();

  Vector2 get _spriteSize => Vector2(16, 16);

  SpriteInfo get topLeft => SpriteInfo(Vector2(0, 0), _spriteSize);

  SpriteInfo get topCenter =>
      SpriteInfo(Vector2(_spriteSize.x * 1, 0), _spriteSize);

  SpriteInfo get topRight =>
      SpriteInfo(Vector2(_spriteSize.x * 2, 0), _spriteSize);

  SpriteInfo get middleLeft =>
      SpriteInfo(Vector2(_spriteSize.x * 3, 0), _spriteSize);

  SpriteInfo get middleCenter =>
      SpriteInfo(Vector2(_spriteSize.x * 4, 0), _spriteSize);

  SpriteInfo get middleRight =>
      SpriteInfo(Vector2(_spriteSize.x * 5, 0), _spriteSize);

  SpriteInfo get bottomLeft =>
      SpriteInfo(Vector2(_spriteSize.x * 6, 0), _spriteSize);

  SpriteInfo get bottomCenter =>
      SpriteInfo(Vector2(_spriteSize.x * 7, 0), _spriteSize);

  SpriteInfo get bottomRight =>
      SpriteInfo(Vector2(_spriteSize.x * 8, 0), _spriteSize);
}

class SpriteInfo {
  final Vector2 position;
  final Vector2 size;

  SpriteInfo(this.position, this.size);
}

class CharacterInfo {
  final int idx;
  final String name;
  final String description;
  final String selectorImagePath;
  final String onSelectorImagePath;
  final String spriteImageLeftPath;
  final String spriteImageJumpPath;
  final int specialValue;

  CharacterInfo(
      {required this.idx,
      required this.name,
      required this.description,
      required this.selectorImagePath,
      required this.onSelectorImagePath,
      required this.spriteImageLeftPath,
      required this.spriteImageJumpPath,
      required this.specialValue});
}
