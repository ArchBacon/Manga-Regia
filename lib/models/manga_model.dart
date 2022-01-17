import 'dart:convert';

class Manga {
  final String id;
  final String title;
  final String coverArtFileName;

  Manga({
    required this.id,
    required this.title,
    required this.coverArtFileName,
  });

  factory Manga.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> coverArt = json['relationships'].reduce((value, element) {
      return element['type'] == 'cover_art' ? element : value;
    });

    return Manga(
      id: json['id'],
      title: json['attributes']['title']['en'],
      coverArtFileName: coverArt['attributes']['fileName'],
    );
  }
}

Manga parseManga(String responseBody) {
  return Manga.fromJson(jsonDecode(responseBody)['data']);
}

List<Manga> parseMangas(String responseBody) {
  final parsed = jsonDecode(responseBody)['data'];

  return parsed.map<Manga>((json) => Manga.fromJson(json)).toList();
}