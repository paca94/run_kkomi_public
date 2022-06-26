import 'dart:collection';

import 'package:flame/components.dart';
import 'package:run_kkomi/game/items/item.dart';
import 'package:run_kkomi/game/kkomi_game.dart';

import 'item_type.dart';

class ItemManager extends Component with HasGameRef<KKomiGame> {
  ItemManager();

  ListQueue<Item> history = ListQueue();
  static const int maxItemDuplication = 2;
  final _itemPool = ItemPool();
  final _useList = [
    ItemType.eight,
    ItemType.t,
    ItemType.h,
    ItemType.h,
    ItemType.a,
    ItemType.p,
    ItemType.p,
    ItemType.y,
    ItemType.b,
    ItemType.i,
    ItemType.r,
    ItemType.t,
    ItemType.h,
    ItemType.d,
    ItemType.a,
    ItemType.y,
  ];
  final _itemTypes = ItemType.values;
  int _currentItemGen = 0;

  @override
  void update(double dt) {
    final items = children.query<Item>();
    final increment = gameRef.currentSpeed * dt;
    final removePools = <Item>[];
    for (final Item item in _itemPool.allocatedPools) {
      if (!items.contains(item)) {
        if (item.x < gameRef.size.x + 300) {
          add(item);
          removePools.add(item);
          continue;
        }
      } else {
        item.x -= increment;
      }
    }
    for (final Item item in removePools) {
      _itemPool.allocatedPools.remove(item);
    }
  }

  void addNewItemAtPosition(Vector2 position) {
    final speed = gameRef.currentSpeed;
    if (speed == 0) {
      return;
    }
    final currentItemType = _useList[_currentItemGen];
    _currentItemGen++;
    _itemPool.getItem(_itemTypes.indexOf(currentItemType), position);
    if (_useList.length <= _currentItemGen) {
      _currentItemGen = 0;
    }
  }

  void reset() {
    for (Item item in children.query<Item>()) {
      item.removeFromParent();
      item.onWithdraw(item);
    }
    history.clear();
    _itemPool.reset();
  }
}

class ItemPool {
  final Map<int, List<Item>> _pool = {};
  final Set<Item> allocatedPools = {};

  reset() {
    for (Item item in allocatedPools) {
      item.isLive = false;
      item.isRender = false;
      item.removeFromParent();
      _pool[item.spriteIdx]!.add(item);
    }
    allocatedPools.clear();
  }

  ItemPool() {
    const int spriteSize = 10;
    const int initSize = 5;
    for (int spriteIdx = 0; spriteIdx < spriteSize; spriteIdx++) {
      _pool[spriteIdx] = List.generate(
        initSize,
        (index) => _newItem(spriteIdx),
      );
    }
  }

  withdraw(Item currentItem) async {
    currentItem.isLive = false;
    currentItem.isRender = false;
    _pool[currentItem.spriteIdx]!.add(currentItem);
  }

  _newItem(int spriteIdx) {
    return Item(
      spriteIdx: spriteIdx,
      onWithdraw: withdraw,
    );
  }

  getItem(int spriteIdx, Vector2 position) {
    late final Item item;
    if (_pool[spriteIdx]!.isEmpty) {
      item = _newItem(spriteIdx);
    } else {
      item = _pool[spriteIdx]!.removeLast();
    }
    item.onAssigned(position);
    allocatedPools.add(item);
    return item;
  }
}
