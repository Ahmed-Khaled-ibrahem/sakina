class PrayerDhikr {
  final int id;
  final String arabicText;
  final String translatedText;
  final String arabicTranslatedText;
  final int repeat;
  final String audio;

  PrayerDhikr({
    required this.id,
    required this.arabicText,
    required this.translatedText,
    required this.arabicTranslatedText,
    required this.repeat,
    required this.audio,
  });

  factory PrayerDhikr.fromJson(Map<String, dynamic> json) {
    return PrayerDhikr(
      id: json['ID'] ?? 0,
      arabicText: json['ARABIC_TEXT'] ?? '',
      translatedText: json['TRANSLATED_TEXT'] ?? '',
      arabicTranslatedText: json['LANGUAGE_ARABIC_TRANSLATED_TEXT'] ?? '',
      repeat: json['REPEAT'] ?? 1,
      audio: json['AUDIO'] ?? '',
    );
  }
}