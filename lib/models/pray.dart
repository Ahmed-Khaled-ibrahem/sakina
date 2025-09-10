class PrayerTimings {
  final String fajr;
  final String dhuhr;
  final String asr;
  final String maghrib;
  final String isha;

  PrayerTimings({
    required this.fajr,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
  });

  factory PrayerTimings.fromJson(Map<String, dynamic> json) {
    return PrayerTimings(
      fajr: json['Fajr'],
      dhuhr: json['Dhuhr'],
      asr: json['Asr'],
      maghrib: json['Maghrib'],
      isha: json['Isha'],
    );
  }
}

class HijriDate {
  final String day;
  final String month;
  final String year;

  HijriDate({required this.day, required this.month, required this.year});

  factory HijriDate.fromJson(Map<String, dynamic> json) {
    return HijriDate(
      day: json['day'],
      month: json['month']['en'], // or 'ar'
      year: json['year'],
    );
  }
}

class PrayerData {
  final PrayerTimings timings;
  final HijriDate hijriDate;

  PrayerData({required this.timings, required this.hijriDate});

  factory PrayerData.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return PrayerData(
      timings: PrayerTimings.fromJson(data['timings']),
      hijriDate: HijriDate.fromJson(data['date']['hijri']),
    );
  }
}
