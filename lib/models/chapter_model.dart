import 'dart:convert';

class Chapter {
  final String id;
  final String? volume;
  final String? chapter;
  final String? title;
  final int pages;

  Chapter({
    required this.id,
    required this.pages,
    this.volume,
    this.chapter,
    this.title,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      id: json['id'],
      volume: json['attributes']['volume'],
      chapter: json['attributes']['chapter'],
      title: json['attributes']['title'],
      pages: json['attributes']['pages'],
    );
  }
}

Chapter parseChapter(String json) {
  return Chapter.fromJson(jsonDecode(json));
}

List<Chapter> parseChapters(String responseBody) {
  final parsed = json.decode(responseBody)['data'].cast<Map<String, dynamic>>();

  return parsed.map<Chapter>((json) => Chapter.fromJson(json)).toList();
}
