import 'package:flutter/material.dart';
import 'package:manga_regia/models/manga_model.dart';
import 'package:manga_regia/services/mangadex_api.dart';
import 'package:manga_regia/widgets/manga_cover.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({Key? key}) : super(key: key);

  final gridDelegate = const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 3,
    childAspectRatio: (130 - 16) / (185 + 56 - 24),
    mainAxisSpacing: 8,
    crossAxisSpacing: 8,
  );

  @override
  _DiscoverPageState createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  late Future<Manga> manga; // TODO: Make list

  @override
  void initState() {
    super.initState();
    refreshMangas();
  }

  Future refreshMangas() async {
    setState(() {
      manga = fetchManga();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover'),
      ),
      body: RefreshIndicator(
        onRefresh: refreshMangas,
        child: FutureBuilder<Manga>(
          future: manga,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }

            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            return GridView.builder(
              gridDelegate: widget.gridDelegate,
              itemCount: 1,
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) => MangaCover(snapshot.data!),
            );
          },
        ),
      ),
    );
  }
}
