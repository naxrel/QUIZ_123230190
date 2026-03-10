import 'package:flutter/material.dart';
import 'package:latihan_kuis_a/screen/checkout_page.dart';
import 'package:latihan_kuis_a/screen/movie_list_page.dart';
import 'package:latihan_kuis_a/screen/profile_page.dart';
import 'package:latihan_kuis_a/screen/saved_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  //main state save index film bookmark dan simpan ketika pindah tab
  final Set<int> _bookmarkedIndices = {};
  //state cart: key = judul film, value = jumlah yang dipesan
  final Map<String, int> _cartQuantities = {};

  //update cart: hapus item jika qty 0, simpan jika qty > 0
  void _updateCart(String movieTitle, int qty) {
    setState(() {
      if (qty <= 0) {
        _cartQuantities.remove(movieTitle);
      } else {
        _cartQuantities[movieTitle] = qty;
      }
    });
  }

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
      //tab 0: daftar semua film + fitur checkout per film
      MovieListPage(
        bookmarkedIndices: _bookmarkedIndices,
        onBookmarkToggle: _toggleBookmark,
        cartQuantities: _cartQuantities,
        onCartUpdate: _updateCart,
      ),
      //tab 1: film yang di-bookmark
      SavedListPage(
        bookmarkedIndices: _bookmarkedIndices,
        onBookmarkToggle: _toggleBookmark,
        cartQuantities: _cartQuantities,
        onCartUpdate: _updateCart,
      ),
      //tab 2: ringkasan checkout + grand total + hapus item
      CheckoutPage(
        cartQuantities: _cartQuantities,
        onCartUpdate: _updateCart,
      ),
      //tab 3: profil user + tombol logout
      const ProfilePage(),
    ];

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        //fixed agar icon & label tetap terlihat saat item >= 4
        type: BottomNavigationBarType.fixed,
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
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            activeIcon: Icon(Icons.shopping_cart),
            label: 'Checkout',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}