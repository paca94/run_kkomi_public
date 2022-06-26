import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:run_kkomi/data/consts.dart';


enum ItemType {
  eight,
  h,
  a,
  p,
  y,
  b,
  i,
  r,
  t,
  d,
}

class ItemTypeSettings {
  const ItemTypeSettings._internal(
    this.type, {
    required this.position,
    required this.size,
    required this.y,
    required this.allowedAt,
    required this.multipleAt,
    required this.generateHitboxes,
  });

  final ItemType type;
  final Vector2 position;
  final Vector2 size;
  final double y;
  final int allowedAt;
  final int multipleAt;

  static const maxGroupSize = 3.0;

  final List<ShapeHitbox> Function() generateHitboxes;

  static final eightItem = ItemTypeSettings._internal(
    ItemType.eight,
    size: Consts.spriteItemInfo.eight.size,
    position: Consts.spriteItemInfo.eight.position,
    y: -32.0,
    allowedAt: 0,
    multipleAt: 0,
    generateHitboxes: () => <ShapeHitbox>[
      RectangleHitbox(
        position: Vector2(0, 0),
        size: Consts.spriteItemInfo.eight.size,
      ),
    ],
  );

  static final hItem = ItemTypeSettings._internal(
    ItemType.h,
    size: Consts.spriteItemInfo.h.size,
    position: Consts.spriteItemInfo.h.position,
    y: -32.0,
    allowedAt: 0,
    multipleAt: 0,
    generateHitboxes: () => <ShapeHitbox>[
      RectangleHitbox(
        position: Vector2(0, 0),
        size: Consts.spriteItemInfo.h.size,
      ),
    ],
  );

  static final aItem = ItemTypeSettings._internal(
    ItemType.a,
    size: Consts.spriteItemInfo.a.size,
    position: Consts.spriteItemInfo.a.position,
    y: -32.0,
    allowedAt: 0,
    multipleAt: 0,
    generateHitboxes: () => <ShapeHitbox>[
      RectangleHitbox(
        position: Vector2(0, 0),
        size: Consts.spriteItemInfo.a.size,
      ),
    ],
  );

  static final pItem = ItemTypeSettings._internal(
    ItemType.p,
    size: Consts.spriteItemInfo.p.size,
    position: Consts.spriteItemInfo.p.position,
    y: -32.0,
    allowedAt: 0,
    multipleAt: 0,
    generateHitboxes: () => <ShapeHitbox>[
      RectangleHitbox(
        position: Vector2(0, 0),
        size: Consts.spriteItemInfo.p.size,
      ),
    ],
  );

  static final yItem = ItemTypeSettings._internal(
    ItemType.eight,
    size: Consts.spriteItemInfo.y.size,
    position: Consts.spriteItemInfo.y.position,
    y: -32.0,
    allowedAt: 0,
    multipleAt: 0,
    generateHitboxes: () => <ShapeHitbox>[
      RectangleHitbox(
        position: Vector2(0, 0),
        size: Consts.spriteItemInfo.y.size,
      ),
    ],
  );

  static final bItem = ItemTypeSettings._internal(
    ItemType.eight,
    size: Consts.spriteItemInfo.b.size,
    position: Consts.spriteItemInfo.b.position,
    y: -32.0,
    allowedAt: 0,
    multipleAt: 0,
    generateHitboxes: () => <ShapeHitbox>[
      RectangleHitbox(
        position: Vector2(0, 0),
        size: Consts.spriteItemInfo.b.size,
      ),
    ],
  );

  static final iItem = ItemTypeSettings._internal(
    ItemType.eight,
    size: Consts.spriteItemInfo.i.size,
    position: Consts.spriteItemInfo.i.position,
    y: -32.0,
    allowedAt: 0,
    multipleAt: 0,
    generateHitboxes: () => <ShapeHitbox>[
      RectangleHitbox(
        position: Vector2(0, 0),
        size: Consts.spriteItemInfo.i.size,
      ),
    ],
  );
  static final rItem = ItemTypeSettings._internal(
    ItemType.eight,
    size: Consts.spriteItemInfo.r.size,
    position: Consts.spriteItemInfo.r.position,
    y: -32.0,
    allowedAt: 0,
    multipleAt: 0,
    generateHitboxes: () => <ShapeHitbox>[
      RectangleHitbox(
        position: Vector2(0, 0),
        size: Consts.spriteItemInfo.r.size,
      ),
    ],
  );
  static final tItem = ItemTypeSettings._internal(
    ItemType.eight,
    size: Consts.spriteItemInfo.t.size,
    position: Consts.spriteItemInfo.t.position,
    y: -32.0,
    allowedAt: 0,
    multipleAt: 0,
    generateHitboxes: () => <ShapeHitbox>[
      RectangleHitbox(
        position: Vector2(0, 0),
        size: Consts.spriteItemInfo.t.size,
      ),
    ],
  );
  static final dItem = ItemTypeSettings._internal(
    ItemType.eight,
    size: Consts.spriteItemInfo.d.size,
    position: Consts.spriteItemInfo.d.position,
    y: -32.0,
    allowedAt: 0,
    multipleAt: 0,
    generateHitboxes: () => <ShapeHitbox>[
      RectangleHitbox(
        position: Vector2(0, 0),
        size: Consts.spriteItemInfo.d.size,
      ),
    ],
  );

  Sprite sprite(Image spriteImage) {
    return Sprite(
      spriteImage,
      srcPosition: position,
      srcSize: size,
    );
  }

  static ItemTypeSettings fromType(ItemType type){
    switch(type){
      case ItemType.eight:
        return ItemTypeSettings.eightItem;
      case ItemType.h:
        return ItemTypeSettings.hItem;
      case ItemType.a:
        return ItemTypeSettings.aItem;
      case ItemType.p:
        return ItemTypeSettings.pItem;
      case ItemType.y:
        return ItemTypeSettings.yItem;
      case ItemType.b:
        return ItemTypeSettings.bItem;
      case ItemType.i:
        return ItemTypeSettings.iItem;
      case ItemType.r:
        return ItemTypeSettings.rItem;
      case ItemType.t:
        return ItemTypeSettings.tItem;
      case ItemType.d:
        return ItemTypeSettings.dItem;
    }
  }
}
