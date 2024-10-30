import 'package:shared_preferences/shared_preferences.dart';
// /private/var/mobile/Containers/Data/Application/21113E6F-8E30-407F-A232-9EB4C951C64A/tmp/mtg_card.db

class SharedPrefs {
  SharedPrefs._internal();
  static SharedPrefs get instance => _singleton;
  static final SharedPrefs _singleton = SharedPrefs._internal();

  SharedPreferences? _prefs;

  Future<SharedPreferences> get prefs async {
    if (_prefs != null) {
      return _prefs!;
    }

    _prefs = await SharedPreferences.getInstance();

    return _prefs!;
  }

  Future<void> setSyncPath(String path) async {
    final prefs = await this.prefs;
    await prefs.setString('dbPath', path);
  }

  Future<String?> getSyncPath() async {
    final prefs = await this.prefs;
    return prefs.getString('dbPath');
  }

  Future<void> clear() async {
    final prefs = await this.prefs;
    await prefs.clear();
  }
}
