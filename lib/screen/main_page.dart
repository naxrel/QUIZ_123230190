import 'package:flutter/material.dart';
import 'package:latihan_kuis_a/screen/movie_list_page.dart';
import 'package:latihan_kuis_a/screen/saved_page.dart';

class MainPage extends StatefulWidget {
  final String username;
  const MainPage({super.key, required this.username});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  //main state save index film bookmark dan simpan ketika pindah tab
  final Set<int> _bookmarkedIndices = {};
  //delete/add bookmark
  void _toggleBookmark(int index) {
    setState(() {
      if (_bookmarkedIndices.contains(index)) {
        _bookmarkedIndices.remove(index);
      } else {
        _bookmarkedIndices.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //list page index tab
    final List<Widget> _pages = [
      MovieListPage(
        username: widget.username,
        bookmarkedIndices: _bookmarkedIndices,
        onBookmarkToggle: _toggleBookmark,
      ),
      SavedListPage(
        bookmarkedIndices: _bookmarkedIndices,
        onBookmarkToggle: _toggleBookmark,
      ),
    ];

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.movie_outlined),
            activeIcon: Icon(Icons.movie),
            label: 'Movies',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border),
            activeIcon: Icon(Icons.bookmark),
            label: 'Saved',
          ),
        ],
      ),
    );
  }
}