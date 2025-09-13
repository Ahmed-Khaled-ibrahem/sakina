class Dhikr {
  final int order;
  final String content;
  final String? translation;
  final String? transliteration;
  final int count;
  final String countDescription;
  final String fadl;
  final String source;
  final int type;
  final String audio;
  final String hadithText;
  final String explanation;

  Dhikr({
    required this.order,
    required this.content,
    this.translation,
    this.transliteration,
    required this.count,
    required this.countDescription,
    required this.fadl,
    required this.source,
    required this.type,
    required this.audio,
    required this.hadithText,
    required this.explanation,
  });

  factory Dhikr.fromJson(Map<String, dynamic> json) {
    return Dhikr(
      order: json['order'],
      content: json['content'],
      translation: json['translation'],
      transliteration: json['transliteration'],
      count: json['count'],
      countDescription: json['count_description'],
      fadl: json['fadl'],
      source: json['source'],
      type: json['type'],
      audio: json['audio'],
      hadithText: json['hadith_text'],
      explanation: json['explanation_of_hadith_vocabulary'],
    );
  }
}