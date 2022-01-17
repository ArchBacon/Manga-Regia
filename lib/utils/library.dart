import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:manga_regia/models/manga_model.dart';
import 'package:path_provider/path_provider.dart';

class Library extends WidgetsBindingObserver {
  static final Library _instance = Library._();
  static List<String> _mangaIds = [];
  static late File libraryFile;

  factory Library() => _instance;

  Library._() {
    getApplicationDocumentsDirectory().then(
      (directory) {
        libraryFile = File('${directory.path}/library.json');
        libraryFile.readAsString().then((json) => _mangaIds = List<String>.from(jsonDecode(json)));
      },
    );
  }

  List<String> get mangaIds => _mangaIds;

  void save() {
    libraryFile.writeAsString(jsonEncode(_mangaIds));

    print('Saved!');
  }

  void clear() {
    _mangaIds = [];
    save();
  }

  void add(Manga manga) {
    _mangaIds.add(manga.id);
    print('Added!');
    save();
  }

  void remove(Manga manga) {
    _mangaIds.remove(manga.id);
    print('Removed!');
    save();
  }

  bool contains(Manga manga) {
    return _mangaIds.contains(manga.id);
  }
}
