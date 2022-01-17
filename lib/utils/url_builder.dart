class UrlBuilder {
  static String coverImage({required String mangaId, required String fileName}) {
    return 'https://uploads.mangadex.org/covers/$mangaId/$fileName.256.jpg';
  }

  static String pageImage({required String hash, required String fileName}) {
    return 'https://uploads.mangadex.org/data-saver/$hash/$fileName';
  }

  static String randomManga() {
    return 'https://api.mangadex.org/manga/random?includes[]=cover_art';
  }

  static String manga({required String mangaId}) {
    return 'https://api.mangadex.org/manga/$mangaId?includes[]=cover_art';
  }

  static String mangas({required List<String> mangaIds}) {
    String url = 'https://api.mangadex.org/manga/?includes[]=cover_art';

    for (var mangaId in mangaIds) {
      url += '&ids[]=$mangaId';
    }

    return url;
  }

  /// [sortOrder] 'asc' or 'desc'
  static String chapters({required String mangaId, String sortOrder = 'asc'}) {
    return 'https://api.mangadex.org/chapter?manga=$mangaId&order[volume]=$sortOrder&order[chapter]=$sortOrder&translatedLanguage[]=en';
  }

  static String pages({required String chapterId}) {
    return 'https://api.mangadex.org/at-home/server/$chapterId';
  }
}
