import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class FirebaseService {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  /// Inserts a new value into your structured Realtime Database
  ///
  /// [type] can be "praying" or "nawafl"
  Future<void> insertPrayerData(String type, String prayTime) async {
    // Validate parameter
    if (type != "praying" && type != "nawafl") {
      throw ArgumentError("Invalid type: must be 'praying' or 'nawafl'");
    }

    // Get current date and time
    final now = DateTime.now();
    final year = now.year.toString();
    final month = now.month.toString();
    final day = now.day.toString();

    // Format time as hh-mm (e.g. 21-11)
    final timeKey = DateFormat('HH-mm').format(now);

    // Build full path
    final path = "150084165317396/$year/$month/$day/$type/$prayTime";

    // Insert value 0
    await _db.child(path).set(0);
  }
}