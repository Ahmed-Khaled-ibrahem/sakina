import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pray.dart';

class PrayerRepository {
  final String baseUrl = "https://api.aladhan.com/v1";

  Future<PrayerData> getPrayerTimes({
    required String city,
    required String country,
    required String date, // format: dd-mm-yyyy
  }) async {
    final url = Uri.parse(
        "$baseUrl/timingsByCity/$date?city=$city&country=$country&method=7");

    final response = await http.get(url);
    print('#####');
    print(response.body);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return PrayerData.fromJson(jsonData);
    } else {
      throw Exception("Failed to load prayer times");
    }
  }
}