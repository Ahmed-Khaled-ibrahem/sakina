import 'package:shared_preferences/shared_preferences.dart';

class BoolListPrefs {
  static const _key = "bool_list_new";

  /// Save list of booleans
  static Future<void> save(List<bool> values) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(_key, values.map((b) => b.toString()).toList());
  }

  /// Load list of booleans
  static Future<List<bool>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key);

    if (list == null) {
      return List<bool>.filled(10, false);
    }

    return list.map((s) => s == "true").toList();
  }
}