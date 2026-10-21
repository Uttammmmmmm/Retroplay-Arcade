import 'package:shared_preferences/shared_preferences.dart';

class LocalGameStorage {
  LocalGameStorage(this._prefs);
  final SharedPreferences _prefs;

  int bestScore(String game) => _prefs.getInt('best.$game') ?? 0;
  Future<void> saveBestScore(String game, int score) async {
    if (score > bestScore(game)) await _prefs.setInt('best.$game', score);
  }

  bool get soundEnabled => _prefs.getBool('sound') ?? true;
  Future<void> setSoundEnabled(bool value) => _prefs.setBool('sound', value);
  Set<String> get favorites => _prefs.getStringList('favorites')?.toSet() ?? {};
  Future<void> toggleFavorite(String game) async {
    final values = favorites;
    if (!values.add(game)) values.remove(game);
    await _prefs.setStringList('favorites', values.toList());
  }
}
