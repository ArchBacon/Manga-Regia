import 'package:flutter/material.dart';
import 'package:manga_regia/utils/library.dart';
import 'package:manga_regia/views/discover_page.dart';
import 'package:manga_regia/views/library_page.dart';

void main() {
  runApp(MaterialApp(
    title: 'Manga Reader App',
    home: const NavBar(
      screens: [
        DiscoverPage(),
        LibraryPage(),
      ],
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Discover'),
        BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Library'),
      ],
    ),
    theme: ThemeData(
      brightness: Brightness.light,
    ),
    darkTheme: ThemeData(
      brightness: Brightness.dark,
    ),
    themeMode: ThemeMode.dark,
  ));
}

class NavBar extends StatefulWidget {
  final List<Widget> screens;
  final List<BottomNavigationBarItem> items;

  const NavBar({Key? key, required this.screens, required this.items}) : super(key: key);

  @override
  NavBarState createState() => NavBarState();
}

class NavBarState extends State<NavBar> {
  int currentScreen = 0;

  @override
  void initState() {
    super.initState();
    Library(); // Create instance of library
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.screens[currentScreen],
      bottomNavigationBar: BottomNavigationBar(
        items: widget.items,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: currentScreen,
        onTap: (index) {
          setState(() {
            currentScreen = index;
          });
        },
      ),
    );
  }
}
