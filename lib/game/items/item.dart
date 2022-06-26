import 'package:flame/collisions.dart';
import 'package:run_kkomi/data/consts.dart';
import 'package:run_kkomi/game/kkomi_game.dart';
import 'package:flame/components.dart';

class Item extends SpriteComponent with HasGameRef<KKomiGame> {
  Item({required this.spriteIdx, required this.onWithdraw})
      : super(size: Vector2(32, 32));

  final commonHitBox = ItemHitBox();

  final int spriteIdx;
  final Function onWithdraw;
  late final Function onWillRemove;

  final double _yMax = 5;
  double _yMoved = 0;
  bool _yMoveUp = true;

  bool followingItemCreated = false;
  late final double gap;

  bool get isVisible => (x + width) > 0;

  bool _isLive = false;

  get isLive => _isLive;

  set isLive(value) => _isLive = value;
  bool _isRender = false;

  get isRender => _isRender;

  set isRender(value) => _isRender = value;

  static final _sprites = [];

  @override
  Future<void> onLoad() async {
    if (_sprites.isEmpty) {
      _sprites.addAll([
        Sprite(
          gameRef.spriteImageOfItem,
          srcPosition: Consts.spriteItemInfo.eight.position,
          srcSize: Consts.spriteItemInfo.eight.size,
        ),
        Sprite(
          gameRef.spriteImageOfItem,
          srcPosition: Consts.spriteItemInfo.h.position,
          srcSize: Consts.spriteItemInfo.h.size,
        ),
        Sprite(
          gameRef.spriteImageOfItem,
          srcPosition: Consts.spriteItemInfo.a.position,
          srcSize: Consts.spriteItemInfo.a.size,
        ),
        Sprite(
          gameRef.spriteImageOfItem,
          srcPosition: Consts.spriteItemInfo.p.position,
          srcSize: Consts.spriteItemInfo.p.size,
        ),
        Sprite(
          gameRef.spriteImageOfItem,
          srcPosition: Consts.spriteItemInfo.y.position,
          srcSize: Consts.spriteItemInfo.y.size,
        ),
        Sprite(
          gameRef.spriteImageOfItem,
          srcPosition: Consts.spriteItemInfo.b.position,
          srcSize: Consts.spriteItemInfo.b.size,
        ),
        Sprite(
          gameRef.spriteImageOfItem,
          srcPosition: Consts.spriteItemInfo.i.position,
          srcSize: Consts.spriteItemInfo.i.size,
        ),
        Sprite(
          gameRef.spriteImageOfItem,
          srcPosition: Consts.spriteItemInfo.r.position,
          srcSize: Consts.spriteItemInfo.r.size,
        ),
        Sprite(
          gameRef.spriteImageOfItem,
          srcPosition: Consts.spriteItemInfo.t.position,
          srcSize: Consts.spriteItemInfo.t.size,
        ),
        Sprite(
          gameRef.spriteImageOfItem,
          srcPosition: Consts.spriteItemInfo.d.position,
          srcSize: Consts.spriteItemInfo.d.size,
        ),
      ]);
    }

    sprite = _sprites[spriteIdx];
    gap = Consts.spriteItemInfo.size.x;
    addAll([commonHitBox]);
  }

  @override
  void update(double dt) {
    super.update(dt);
    final double diff = gameRef.currentSpeed * dt;
    x -= diff;
    final smallDiff = diff / 50;
    if (_yMoveUp) {
      _yMoved -= smallDiff;
      y -= smallDiff;
      if (_yMoved < -_yMax) {
        _yMoveUp = !_yMoveUp;
      }
    } else {
      _yMoved += smallDiff;
      y += smallDiff;
      if (_yMoved > _yMax) {
        _yMoveUp = !_yMoveUp;
      }
    }
    if (!isVisible && _isLive) {
      _isLive = false;
      removeFromParent();
      onWithdraw(this);
    }
  }

  void onEat() {
    gameRef.addScore(this);

    coinSoundPlay();
    _isLive = false;
    removeFromParent();
    onWithdraw(this);
  }

  coinSoundPlay() async {
    await gameRef.soundManager.coin.play();
  }

  void onAssigned(final Vector2 newPosition) {
    _isLive = true;
    x = newPosition.x;
    y = newPosition.y;
  }
}

class ItemHitBox extends RectangleHitbox {
  ItemHitBox()
      : super(
          position: Vector2(0.0, 0.0),
          size: Consts.spriteItemInfo.size,
        );
  // If you don't do this, you'll get a lot of lag due to collision handling.
  @override
  CollisionType collisionType = CollisionType.passive;
}
