import 'package:flutter/services.dart';
import 'package:run_kkomi/data/consts.dart';
import 'package:soundpool/soundpool.dart';

// hot reload시, 오디오플레이어를 초기화하지 못하는 버그 수정해야함.
class SoundManager {
  final background = Sound('background', Consts.soundPath.backgroundMusic,
      volume: 0.5, loop: true);
  final jump = Sound('jump', Consts.soundPath.jumpSound, volume: 0.2);
  final coin = Sound('coin', Consts.soundPath.coinSound, volume: 0.2);
  final click = Sound('click', Consts.soundPath.clickSound, volume: 0.4);

  init() async {
    await background.init();
    await jump.init();
    await coin.init();
    await click.init();
  }
}

class Sound {
  final String playerId;
  final String targetSoundPath;
  final double? volume;
  final bool? loop;
  late final Soundpool _player;
  late final int _soundId;
  late Future<int> _streamId;

  bool _isInit = false;

  Sound(this.playerId, this.targetSoundPath, {this.volume, this.loop}) {
    _player = Soundpool.fromOptions(options: const SoundpoolOptions());
  }

  init() async {
    if (_isInit) return;
    _isInit = true;
    var asset = await rootBundle.load(targetSoundPath);
    _soundId = await _player.load(asset);
    await _soundId;
    await _player.setVolume(soundId: _soundId, volume: volume ?? 1);
  }

  play() {
    if (loop ?? false) {
      _streamId = _player.play(_soundId, repeat: 100);
    } else {
      _player.play(_soundId);
    }
  }

  stop() async {
    final id = await _streamId;
    _player.stop(id);
  }

  pause() async {
    final id = await _streamId;
    _player.pause(id);
  }
}
