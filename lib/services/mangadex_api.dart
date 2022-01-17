import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:manga_regia/models/chapter_model.dart';
import 'package:manga_regia/models/manga_model.dart';
import 'package:manga_regia/models/pages_model.dart';
import 'package:manga_regia/utils/url_builder.dart';

Future<Manga> fetchManga() async {
  final response = await http.get(Uri.parse(UrlBuilder.randomManga()));

  return compute(parseManga, response.body);
}

Future<List<Manga>> fetchMangas(List<String> mangaIds) async {
  if (mangaIds.isEmpty) {
    return <Manga>[];
  }

  final response = await http.get(Uri.parse(UrlBuilder.mangas(mangaIds: mangaIds)));

  return compute(parseMangas, response.body);
}

Future<List<Chapter>> fetchChapters(String mangaId, {String sortOrder = 'asc'}) async {
  final response = await http.get(Uri.parse(UrlBuilder.chapters(mangaId: mangaId)));

  return compute(parseChapters, response.body);
}

Future<Pages> fetchPages(String chapterId) async {
  final response = await http.get(Uri.parse(UrlBuilder.pages(chapterId: chapterId)));

  return compute(parsePages, response.body);
}
