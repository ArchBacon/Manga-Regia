import 'package:flutter/material.dart';
import 'package:manga_regia/models/chapter_model.dart';
import 'package:manga_regia/models/manga_model.dart';
import 'package:manga_regia/services/mangadex_api.dart';
import 'package:manga_regia/utils/library.dart';
import 'package:manga_regia/views/reading_page.dart';

class ChapterPage extends StatefulWidget {
  final Manga manga;

  const ChapterPage(this.manga, {Key? key}) : super(key: key);

  @override
  _ChapterPageState createState() => _ChapterPageState();
}

class _ChapterPageState extends State<ChapterPage> {
  late Future<List<Chapter>> chapters;

  @override
  void initState() {
    super.initState();
    refreshChapters();
  }

  Future refreshChapters() async {
    setState(() {
      chapters = fetchChapters(widget.manga.id);
    });
  }

  Widget buildChapterRow(Chapter chapter) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ReadingPage(chapter: chapter, mangaTitle: widget.manga.title)));
      },
      child: ListTile(
        tileColor: Colors.grey[800],
        title: Row(
          children: [
            if (chapter.volume != null) Text('vol. ${chapter.volume} ', overflow: TextOverflow.ellipsis, maxLines: 1),
            if (chapter.chapter != null) Text('ch. ${chapter.chapter} ', overflow: TextOverflow.ellipsis, maxLines: 1),
            if (chapter.title != null) Flexible(child: Text(chapter.title!, overflow: TextOverflow.ellipsis, maxLines: 1)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.manga.title,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            icon: Library().contains(widget.manga) ? const Icon(Icons.bookmark) : const Icon(Icons.bookmark_border),
            onPressed: () {
              Library().contains(widget.manga) ? Library().remove(widget.manga) : Library().add(widget.manga);

              setState(() {});
            },
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: refreshChapters,
        child: FutureBuilder<List<Chapter>>(
          future: chapters,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }

            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.remove_red_eye,
                      size: 50,
                    ),
                    Text('Nothing here, yet!'),
                  ],
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.only(top: 3),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final Chapter chapter = snapshot.data![index];

                return buildChapterRow(chapter);
              },
              separatorBuilder: (BuildContext context, int index) => const Padding(padding: EdgeInsets.only(top: 3)),
            );
          },
        ),
      ),
    );
  }
}
