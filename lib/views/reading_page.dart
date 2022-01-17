import 'dart:async';

import 'package:flutter/material.dart';
import 'package:manga_regia/models/chapter_model.dart';
import 'package:manga_regia/models/pages_model.dart';
import 'package:manga_regia/services/mangadex_api.dart';
import 'package:manga_regia/utils/url_builder.dart';
import 'package:manga_regia/widgets/sliding_appbar.dart';

class ReadingPage extends StatefulWidget {
  final Chapter chapter;
  final String mangaTitle;
  final bool rtl;

  const ReadingPage({
    required this.chapter,
    required this.mangaTitle,
    this.rtl = true,
    Key? key,
  }) : super(key: key);

  @override
  _ReadingPageState createState() => _ReadingPageState();
}

class _ReadingPageState extends State<ReadingPage> with SingleTickerProviderStateMixin {
  late PageController controller;
  int currentPage = 0;
  late Future<Pages> pages;
  bool showToolbar = true;
  late AnimationController animationController;

  @override
  void initState() {
    controller = PageController(initialPage: currentPage);
    animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    pages = fetchPages(widget.chapter.id);
    preCacheImages();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() {
        showToolbar = !showToolbar;
      }),
      child: SafeArea(
        child: Scaffold(
          appBar: FadingAppBar(
            controller: animationController,
            visible: showToolbar,
            child: AppBar(title: buildTitle()),
          ),
          body: FutureBuilder<Pages>(
            future: pages,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              }

              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              return buildPageView(snapshot.data!);
            },
          ),
          bottomNavigationBar: FadingAppBar(
            controller: animationController,
            visible: showToolbar,
            child: BottomAppBar(
              color: Colors.transparent,
              elevation: 0,
              child: SizedBox(
                height: kToolbarHeight,
                child: Center(child: Text('${currentPage + 1} / ${widget.chapter.pages}')),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void preCacheImages() async {
    final awaitedPages = await pages;
    for (var fileName in awaitedPages.pages) {
      precacheImage(NetworkImage(UrlBuilder.pageImage(hash: awaitedPages.hash, fileName: fileName)), context);
    }
  }

  Widget buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.mangaTitle),
        Row(
          children: [
            if (widget.chapter.volume != null) Text('vol. ${widget.chapter.volume} ', style: const TextStyle(fontSize: 16)),
            if (widget.chapter.chapter != null) Text('ch. ${widget.chapter.chapter} ', style: const TextStyle(fontSize: 16)),
            if (widget.chapter.title != null)
              Flexible(
                child: Text(widget.chapter.title!, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 16)),
              )
          ],
        ),
      ],
    );
  }

  Widget buildPageView(Pages pages) {
    return NotificationListener<ScrollStartNotification>(
      onNotification: (notification) {
        if (showToolbar) {
          Timer(
            const Duration(milliseconds: 400),
            () => setState(() {
              showToolbar = false;
            }),
          );
        }

        return true;
      },
      child: PageView.builder(
        onPageChanged: (value) {
          setState(() {
            currentPage = value;
          });
        },
        reverse: true,
        itemCount: pages.pages.length,
        controller: controller,
        itemBuilder: (context, index) => Stack(
          children: [
            const Center(child: CircularProgressIndicator()),
            Center(child: Image.network(UrlBuilder.pageImage(hash: pages.hash, fileName: pages.pages[index]))),
          ],
        ),
      ),
    );
  }
}
