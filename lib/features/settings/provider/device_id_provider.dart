import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final textValueProvider =
StateNotifierProvider<TextValueNotifier, String?>((ref) {
  return TextValueNotifier()..loadValue();
});

class TextValueNotifier extends StateNotifier<String?> {
  TextValueNotifier() : super(null);

  static const _key = 'saved_text';

  Future<void> loadValue() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getString(_key);
    print(state);
  }

  Future<void> setValue(String newValue) async {
    state = newValue;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, newValue);
  }
}