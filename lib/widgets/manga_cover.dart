import 'package:flutter/material.dart';
import 'package:manga_regia/models/manga_model.dart';
import 'package:manga_regia/utils/url_builder.dart';
import 'package:manga_regia/views/chapter_list_page.dart';

class MangaCover extends StatelessWidget {
  final Manga manga;

  const MangaCover(this.manga, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.grey[800],
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: (130 + 3.5) / 185,
                child: Image.network(
                  UrlBuilder.coverImage(mangaId: manga.id, fileName: manga.coverArtFileName),
                  fit: BoxFit.cover,
                ),
              ),
              ListTile(
                title: Text(
                  manga.title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ChapterPage(manga)));
            },
          ),
        )
      ],
    );
  }
}
