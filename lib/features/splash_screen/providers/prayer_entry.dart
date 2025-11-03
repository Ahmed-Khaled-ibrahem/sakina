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

// Modified filter function that accepts any date
List<PrayerEntry> filterByDate(List<PrayerEntry> all, DateTime targetDate) {
  return all
      .where(
        (entry) =>
    entry.dateTime.year == targetDate.year &&
        entry.dateTime.month == targetDate.month &&
        entry.dateTime.day == targetDate.day,
  )
      .toList();
}

// State provider to hold the selected date (defaults to today)
final selectedDateProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});

// Provider that returns entries for the selected date
final dailyEntriesProvider = Provider<List<PrayerEntry>>((ref) {
  final raw = ref.watch(realtimeDataStateProvider);
  if (raw == null) return [];

  final selectedDate = ref.watch(selectedDateProvider);
  final parsed = parseRealtimeData(raw);
  return filterByDate(parsed, selectedDate);
});

// Convenience provider for today's entries (optional - for backward compatibility)
final todaysEntriesProvider = Provider<List<PrayerEntry>>((ref) {
  final raw = ref.watch(realtimeDataStateProvider);
  if (raw == null) return [];

  final parsed = parseRealtimeData(raw);
  return filterByDate(parsed, DateTime.now());
});

// Optional: Provider to get all parsed entries without filtering
final allEntriesProvider = Provider<List<PrayerEntry>>((ref) {
  final raw = ref.watch(realtimeDataStateProvider);
  if (raw == null) return [];

  return parseRealtimeData(raw);
});

// Optional: Provider to get entries for a specific date range
final dateRangeEntriesProvider = Provider<List<PrayerEntry>>((ref) {
  final raw = ref.watch(realtimeDataStateProvider);
  if (raw == null) return [];

  final startDate = ref.watch(startDateProvider);
  final endDate = ref.watch(endDateProvider);

  final parsed = parseRealtimeData(raw);

  return parsed.where((entry) {
    return entry.dateTime.isAfter(startDate.subtract(const Duration(days: 1))) &&
        entry.dateTime.isBefore(endDate.add(const Duration(days: 1)));
  }).toList();
});

// State providers for date range (optional)
final startDateProvider = StateProvider<DateTime>((ref) {
  return DateTime.now().subtract(const Duration(days: 7));
});

final endDateProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});