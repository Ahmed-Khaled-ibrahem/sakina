import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_database/firebase_database.dart';

final realtimeDataStateProvider = StateProvider<Map<String, dynamic>?>(
  (ref) => null,
);

final realtimeDatabaseProvider =
    StreamProvider.family<Map<String, dynamic>?, String>((ref, path) {
      final refDb = FirebaseDatabase.instance.ref(path);
      return refDb.onValue.map((event) {
        if (event.snapshot.exists && event.snapshot.value is Map) {
          final data = Map<String, dynamic>.from(event.snapshot.value as Map);
          ref.read(realtimeDataStateProvider.notifier).state = data;
          print(data);
          return data;
        }
        return null;
      });
    });
