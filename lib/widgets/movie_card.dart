import 'package:flutter/material.dart';
import 'package:latihan_kuis_a/models/movie_model.dart';

class MovieCard extends StatelessWidget {
  final MovieModel movie;
  final int index;
  final bool isBookmarked;
  final Function(int) onBookmarkToggle;
  final VoidCallback onTap;

  const MovieCard({
    super.key,
    required this.movie,
    required this.index,
    required this.isBookmarked,
    required this.onBookmarkToggle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //poster
              Container(
                width: 90,
                height: 110,
                color: Colors.grey[300],
                child: Image.network(
                  movie.imgUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image),
                ),
              ),
              const SizedBox(width: 12),
              
              //info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${movie.title} (${movie.year})",
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: "Inter",
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      movie.genre,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.orange, size: 18),
                        const SizedBox(width: 2),
                        Text("${movie.rating}/10", style: const TextStyle(fontFamily: "Inter")),

                      ],
                    ),
                  ],
                ),
              ),
              
              //bookmark
              IconButton(
                onPressed: () => onBookmarkToggle(index),
                icon: Icon(
                  isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  color: isBookmarked ? Colors.blue : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}