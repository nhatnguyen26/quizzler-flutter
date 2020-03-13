import 'package:audioplayers/audio_cache.dart';

class SoundBox {
  final AudioCache _audioCache = AudioCache();

  void playSuccess() {
    _audioCache.play('bicycle_bell.wav');
  }

  void playFailure() {
    _audioCache.play('blip.wav');
  }
}
