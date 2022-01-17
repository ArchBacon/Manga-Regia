import 'dart:convert';

class Pages {
  final String baseUrl;
  final String hash;
  final List<String> pages;

  Pages({
    required this.baseUrl,
    required this.hash,
    required this.pages,
  });

  factory Pages.fromJson(Map<String, dynamic> json) {
    return Pages(
      baseUrl: json['baseUrl'],
      hash: json['chapter']['hash'],
      pages: List<String>.from(json['chapter']['dataSaver']),
    );
  }
}

Pages parsePages(String responseBody) {
  return Pages.fromJson(jsonDecode(responseBody));
}