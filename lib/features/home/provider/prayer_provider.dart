import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../models/pray.dart';
import '../../../repo/prayer_repo.dart';
import 'city_provider.dart';

final prayerRepositoryProvider = Provider((ref) => PrayerRepository());

final prayerProvider = FutureProvider<PrayerData>((ref) async {
  final repo = ref.watch(prayerRepositoryProvider);
  final location = ref.read(locationProvider);

  final city = location.value?.split('\n')[0].trim().toLowerCase();
  final country = location.value?.split('\n')[1].trim().toUpperCase();

  return repo.getPrayerTimes(
    city: city ?? 'jeddah',
    country: country ?? 'saudi arabia',
    date: DateFormat('dd-MM-yyyy').format(DateTime.now()),
  );
});
