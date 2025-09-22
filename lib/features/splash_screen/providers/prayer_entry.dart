import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:praying_app/features/splash_screen/providers/real_time_data.dart';

class PrayerEntry {
  final DateTime dateTime;
  final String category;
  final int value;

  PrayerEntry({
    required this.dateTime,
    required this.category,
    required this.value,
  });
}

List<PrayerEntry> parseRealtimeData(Map<String, dynamic> raw) {
  final entries = <PrayerEntry>[];

  raw.forEach((chipId, years) {
    (years as Map).forEach((year, months) {
      (months as Map).forEach((month, days) {
        (days as Map).forEach((day, categories) {
          (categories as Map).forEach((category, times) {
            (times as Map).forEach((time, value) {
              // Convert year/month/day/time into DateTime
              final parts = time.toString().split(RegExp(r"[:-]"));
              final hour = int.parse(parts[0]);
              final minute = int.parse(parts[1]);

              final dateTime = DateTime(
                int.parse(year.toString()),
                int.parse(month.toString()),
                int.parse(day.toString()),
                hour,
                minute,
              );

              entries.add(
                PrayerEntry(
                  dateTime: dateTime,
                  category: category.toString(),
                  value: int.parse(value.toString()),
                ),
              );
            });
          });
        });
      });
    });
  });

  return entries;
}

List<PrayerEntry> filterToday(List<PrayerEntry> all) {
  final now = DateTime.now();
  return all
      .where(
        (entry) =>
            entry.dateTime.year == now.year &&
            entry.dateTime.month == now.month &&
            entry.dateTime.day == now.day,
      )
      .toList();
}


final todaysEntriesProvider = Provider<List<PrayerEntry>>((ref) {
  final raw = ref.watch(realtimeDataStateProvider);
  if (raw == null) return [];

  final parsed = parseRealtimeData(raw);
  return filterToday(parsed);
});