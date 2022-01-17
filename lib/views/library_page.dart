import 'package:flutter/material.dart';
import 'package:manga_regia/services/mangadex_api.dart';
import 'package:manga_regia/utils/library.dart';
import 'package:manga_regia/widgets/manga_grid.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({Key? key}) : super(key: key);

  @override
  _LibraryState createState() => _LibraryState();
}

class _LibraryState extends State<LibraryPage> {
  late List<String> library;

  @override
  void initState() {
    super.initState();
    refreshLibrary();
  }

  refreshLibrary() {
    setState(() {
      library = Library().mangaIds;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Library'),
      ),
      body: MangaGrid(
        future: fetchMangas(library),
        noDataMessage: Column(
          children: const [
            Text('Found something you like?'),
            Text('Bookmark it to make it appear here!'),
          ],
        ),
      ),
    );
  }
}
