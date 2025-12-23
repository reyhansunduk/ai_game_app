import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/story_state.dart';

class SaveService {
  static const String _savesKey = 'story_saves';
  static const String _autoSaveKey = 'auto_save';

  /// Hikayeyi kaydet
  Future<bool> saveStory(StoryState state, {bool isAutoSave = false}) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Otomatik kayıt ise
      if (isAutoSave) {
        final json = jsonEncode(state.toJson());
        return await prefs.setString(_autoSaveKey, json);
      }

      // Manuel kayıt - tüm kayıtları al
      final savesJson = prefs.getString(_savesKey);
      Map<String, dynamic> saves = {};

      if (savesJson != null) {
        saves = jsonDecode(savesJson) as Map<String, dynamic>;
      }

      // Yeni save ID oluştur
      final saveId = state.saveId ?? DateTime.now().millisecondsSinceEpoch.toString();
      final stateWithId = state.copyWith(saveId: saveId);

      saves[saveId] = stateWithId.toJson();

      // Kaydet
      final json = jsonEncode(saves);
      return await prefs.setString(_savesKey, json);
    } catch (e) {
      return false;
    }
  }

  /// Otomatik kaydı yükle
  Future<StoryState?> loadAutoSave() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = prefs.getString(_autoSaveKey);

      if (json == null) return null;

      final map = jsonDecode(json) as Map<String, dynamic>;
      return StoryState.fromJson(map);
    } catch (e) {
      return null;
    }
  }

  /// Tüm kayıtları listele
  Future<List<SavedStory>> listSaves() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savesJson = prefs.getString(_savesKey);

      if (savesJson == null) return [];

      final saves = jsonDecode(savesJson) as Map<String, dynamic>;

      final List<SavedStory> savedStories = [];

      saves.forEach((key, value) {
        try {
          final state = StoryState.fromJson(value as Map<String, dynamic>);
          savedStories.add(SavedStory(
            id: key,
            state: state,
            savedAt: state.createdAt,
          ));
        } catch (e) {
          // Hatalı kayıtları atla
        }
      });

      // Tarihe göre sırala (en yeni en üstte)
      savedStories.sort((a, b) => b.savedAt.compareTo(a.savedAt));

      return savedStories;
    } catch (e) {
      return [];
    }
  }

  /// Belirli bir kayıtı yükle
  Future<StoryState?> loadSave(String saveId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savesJson = prefs.getString(_savesKey);

      if (savesJson == null) return null;

      final saves = jsonDecode(savesJson) as Map<String, dynamic>;

      if (!saves.containsKey(saveId)) return null;

      return StoryState.fromJson(saves[saveId] as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

  /// Kayıtı sil
  Future<bool> deleteSave(String saveId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savesJson = prefs.getString(_savesKey);

      if (savesJson == null) return false;

      final saves = jsonDecode(savesJson) as Map<String, dynamic>;
      saves.remove(saveId);

      final json = jsonEncode(saves);
      return await prefs.setString(_savesKey, json);
    } catch (e) {
      return false;
    }
  }

  /// Otomatik kayıtı sil
  Future<bool> deleteAutoSave() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_autoSaveKey);
    } catch (e) {
      return false;
    }
  }

  /// Tüm kayıtları sil
  Future<bool> deleteAllSaves() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_savesKey);
      await prefs.remove(_autoSaveKey);
      return true;
    } catch (e) {
      return false;
    }
  }
}

/// Kaydedilmiş hikaye bilgisi
class SavedStory {
  final String id;
  final StoryState state;
  final DateTime savedAt;

  SavedStory({
    required this.id,
    required this.state,
    required this.savedAt,
  });

  String get title {
    final genre = state.genre.isNotEmpty ? state.genre : 'Bilinmeyen';
    final storyLength = state.history.length;
    return '$genre - $storyLength bölüm';
  }

  String get preview {
    if (state.currentText.isEmpty) return 'Boş hikaye';
    return state.currentText.length > 100
        ? '${state.currentText.substring(0, 100)}...'
        : state.currentText;
  }
}
