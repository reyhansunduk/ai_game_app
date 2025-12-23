import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _musicPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();

  bool _isMusicEnabled = true;
  bool _isSfxEnabled = true;
  double _musicVolume = 0.3;
  double _sfxVolume = 0.7;

  bool get isMusicEnabled => _isMusicEnabled;
  bool get isSfxEnabled => _isSfxEnabled;

  /// Müzik ayarlarını değiştir
  void toggleMusic() {
    _isMusicEnabled = !_isMusicEnabled;
    if (!_isMusicEnabled) {
      _musicPlayer.stop();
    }
  }

  /// Ses efektleri ayarlarını değiştir
  void toggleSfx() {
    _isSfxEnabled = !_isSfxEnabled;
  }

  /// Arka plan müziği çal (genre'ye göre)
  Future<void> playBackgroundMusic(String genre) async {
    if (!_isMusicEnabled) return;

    try {
      await _musicPlayer.setVolume(_musicVolume);
      await _musicPlayer.setReleaseMode(ReleaseMode.loop);

      // Genre'ye göre müzik seçimi (şimdilik placeholder)
      // Gerçek müzik dosyaları eklendiğinde kullanılacak
      String musicFile = _getMusicForGenre(genre);

      // Web platformunda ses dosyaları farklı şekilde yüklenir
      if (kIsWeb) {
        await _musicPlayer.play(AssetSource(musicFile));
      } else {
        await _musicPlayer.play(AssetSource(musicFile));
      }
    } catch (e) {
      debugPrint('Müzik çalma hatası: $e');
    }
  }

  /// Ses efekti çal
  Future<void> playSfx(String sfxType) async {
    if (!_isSfxEnabled) return;

    try {
      await _sfxPlayer.setVolume(_sfxVolume);

      String sfxFile = _getSfxFile(sfxType);

      if (kIsWeb) {
        await _sfxPlayer.play(AssetSource(sfxFile));
      } else {
        await _sfxPlayer.play(AssetSource(sfxFile));
      }
    } catch (e) {
      debugPrint('Ses efekti çalma hatası: $e');
    }
  }

  /// Genre'ye göre müzik dosyası seç
  String _getMusicForGenre(String genre) {
    switch (genre.toLowerCase()) {
      case 'macera':
        return 'sounds/adventure_bg.mp3';
      case 'korku':
        return 'sounds/horror_bg.mp3';
      case 'bilim kurgu':
        return 'sounds/scifi_bg.mp3';
      case 'fantastik':
        return 'sounds/fantasy_bg.mp3';
      default:
        return 'sounds/default_bg.mp3';
    }
  }

  /// Ses efekti dosyası seç
  String _getSfxFile(String sfxType) {
    switch (sfxType) {
      case 'choice':
        return 'sounds/choice_click.mp3';
      case 'story_start':
        return 'sounds/story_start.mp3';
      case 'story_end':
        return 'sounds/story_end.mp3';
      case 'page_turn':
        return 'sounds/page_turn.mp3';
      case 'success':
        return 'sounds/success.mp3';
      case 'danger':
        return 'sounds/danger.mp3';
      default:
        return 'sounds/click.mp3';
    }
  }

  /// Müziği durdur
  Future<void> stopMusic() async {
    await _musicPlayer.stop();
  }

  /// Tüm sesleri durdur
  Future<void> stopAll() async {
    await _musicPlayer.stop();
    await _sfxPlayer.stop();
  }

  /// Kaynakları temizle
  void dispose() {
    _musicPlayer.dispose();
    _sfxPlayer.dispose();
  }
}
