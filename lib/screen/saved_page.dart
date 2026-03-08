import 'package:flutter/material.dart';
import 'package:latihan_kuis_a/models/movie_model.dart';
import 'package:latihan_kuis_a/screen/movie_list_page.dart';
import 'package:latihan_kuis_a/widgets/movie_card.dart';

class SavedListPage extends StatelessWidget {
  final Set<int> bookmarkedIndices;
  final Function(int) onBookmarkToggle;

  const SavedListPage({
    super.key,
    required this.bookmarkedIndices,
    required this.onBookmarkToggle,
  });

  @override
  Widget build(BuildContext context) {
    //filter movieList berdasarkan bookmarkedIndices untuk ditampilkan di halaman saved
    final savedMovies = movieList.asMap().entries
        .where((entry) => bookmarkedIndices.contains(entry.key))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorite Movies"),
        centerTitle: true,
      ),
      body: savedMovies.isEmpty
          ? const Center(
              child: Text("Belum ada film yang disimpan."),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: savedMovies.length,
              itemBuilder: (context, index) {
                final movieIndex = savedMovies[index].key;
                final movie = savedMovies[index].value;

                return MovieCard(
                  movie: movie,
                  index: movieIndex,
                  isBookmarked: true,
                  onBookmarkToggle: onBookmarkToggle,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MovieDetailPage(movie: movie),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}