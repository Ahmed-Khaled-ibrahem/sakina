import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../model/azkar_model.dart';
import '../model/prayer_zekr_model.dart';

class DhikrHelper {
  static Future<List<Dhikr>> loadDhikr(String path) async {
    final jsonString = await rootBundle.loadString(path);
    final List<dynamic> data = json.decode(jsonString);
    return data.map((item) => Dhikr.fromJson(item)).toList();
  }
}


class PrayerDhikrHelper {
  static Future<List<PrayerDhikr>> loadPrayerDhikr(String path) async {
    final String jsonString = await rootBundle.loadString(path);
    final Map<String, dynamic> jsonData = json.decode(jsonString);
    final List<dynamic> items = jsonData["الأذكار بعد السلام من الصلاة"];

    return items.map((e) => PrayerDhikr.fromJson(e)).toList();
  }
}