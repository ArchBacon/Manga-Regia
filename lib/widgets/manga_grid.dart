import 'package:flutter/material.dart';
import 'package:manga_regia/models/manga_model.dart';
import 'package:manga_regia/widgets/manga_cover.dart';

class MangaGrid extends StatelessWidget {
  final Future<List<Manga>> future;
  final Widget? noDataMessage;

  final gridDelegate = const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 3,
    childAspectRatio: (130 - 16) / (185 + 56 - 24),
    mainAxisSpacing: 8,
    crossAxisSpacing: 8,
  );

  const MangaGrid({Key? key, required this.future, this.noDataMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Manga>>(
      future: future,
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
              children: [
                const Icon(
                  Icons.remove_red_eye,
                  size: 50,
                ),
                noDataMessage ?? const Text('Nothing here, yet!'),
              ],
            ),
          );
        }

        return GridView.builder(
          gridDelegate: gridDelegate,
          itemCount: snapshot.data!.length,
          padding: const EdgeInsets.all(8),
          itemBuilder: (context, index) => MangaCover(snapshot.data![index]),
        );
      },
    );
  }
}
