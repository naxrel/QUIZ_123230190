import 'package:flutter/material.dart';
import 'package:latihan_kuis_a/models/movie_model.dart';
import 'package:latihan_kuis_a/models/user.dart';
import 'package:latihan_kuis_a/screen/checkout_page.dart';
import 'package:latihan_kuis_a/widgets/movie_card.dart';

class MovieListPage extends StatelessWidget {
  //parameter untuk data dari MainPage
  final Set<int> bookmarkedIndices;
  final Function(int) onBookmarkToggle;
  final Map<String, int> cartQuantities;
  final Function(String, int) onCartUpdate;

  const MovieListPage({
    super.key,
    required this.bookmarkedIndices,
    required this.onBookmarkToggle,
    required this.cartQuantities,
    required this.onCartUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Welcome, ${user1.nama}!",
                style: const TextStyle(
                  fontSize: 20, 
                  fontWeight: FontWeight.bold, 
                  fontFamily: "Inter"
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: movieList.length,
                itemBuilder: (context, index) {
                  final movie = movieList[index];
                  //cek status bookmark
                  final isBookmarked = bookmarkedIndices.contains(index);

                  return MovieCard(
                    movie: movie,
                    index: index,
                    isBookmarked: isBookmarked,
                    onBookmarkToggle: onBookmarkToggle,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MovieDetailPage(
                            movie: movie,
                            initialQty: cartQuantities[movie.title] ?? 0,
                            cartQuantities: cartQuantities,
                            onCartUpdate: onCartUpdate,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MovieDetailPage extends StatefulWidget {
  final MovieModel movie;
  final int initialQty;
  final Map<String, int> cartQuantities;
  final Function(String, int) onCartUpdate;

  const MovieDetailPage({
    super.key,
    required this.movie,
    required this.initialQty,
    required this.cartQuantities,
    required this.onCartUpdate,
  });

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  late int _qty;

  @override
  void initState() {
    super.initState();
    _qty = widget.initialQty;
  }

  // sync qty jika initialQty berubah dari luar (misal item dihapus di checkout)
  @override
  void didUpdateWidget(MovieDetailPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialQty != widget.initialQty) {
      setState(() => _qty = widget.initialQty);
    }
  }

  void _changeQty(int delta) {
    final newQty = (_qty + delta).clamp(0, 99);
    setState(() => _qty = newQty);
    widget.onCartUpdate(widget.movie.title, newQty);
  }

  String _formatPrice(int price) {
    final str = price.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buffer.write('.');
      buffer.write(str[i]);
    }
    return 'Rp ${buffer.toString()}';
  }

  @override
  Widget build(BuildContext context) {
    final movie = widget.movie;
    final imageWidget = movie.imgUrl.startsWith('assets/')
        ? Image.asset(
            movie.imgUrl,
            width: double.infinity,
            height: 350,
            fit: BoxFit.contain,
            alignment: Alignment.center,
            errorBuilder: (context, error, stackTrace) => Container(
              height: 350,
              color: Colors.grey[300],
              child: const Icon(Icons.broken_image, size: 50),
            ),
          )
        : Image.network(
            movie.imgUrl,
            width: double.infinity,
            height: 350,
            fit: BoxFit.contain,
            alignment: Alignment.center,
            errorBuilder: (context, error, stackTrace) => Container(
              height: 350,
              color: Colors.grey[300],
              child: const Icon(Icons.broken_image, size: 50),
            ),
          );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Movie Details"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            imageWidget,
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${movie.title} (${movie.year})",
                    style: const TextStyle(
                      fontSize: 22,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Directed by ${movie.director}",
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    movie.synopsis,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Genre: ${movie.genre}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Casts : ${movie.casts.join(', ')}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.star, color: Colors.orange, size: 30),
                        const SizedBox(width: 8),
                        Text(
                          "Rated ${movie.rating}/10",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 12),
                  // Harga satuan
                  Text(
                    "Harga: ${_formatPrice(movie.price)}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Row: [Jumlah Pesan - qty +] [Harga Total]
                  Row(
                    children: [
                      // bordered counter box
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              child: Text(
                                "Jumlah Pesan",
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                            // tombol minus
                            InkWell(
                              onTap: _qty > 0 ? () => _changeQty(-1) : null,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                decoration: const BoxDecoration(
                                  border: Border(
                                    left: BorderSide(color: Colors.grey),
                                    right: BorderSide(color: Colors.grey),
                                  ),
                                ),
                                child: Text(
                                  "-",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: _qty > 0 ? Colors.black : Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                            // angka qty
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              child: Text(
                                "$_qty",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            // tombol plus
                            InkWell(
                              onTap: () => _changeQty(1),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                decoration: const BoxDecoration(
                                  border: Border(
                                    left: BorderSide(color: Colors.grey),
                                  ),
                                ),
                                child: const Text(
                                  "+",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Harga total
                      Expanded(
                        child: Text(
                          _qty > 0
                              ? _formatPrice(movie.price * _qty)
                              : "Harga Total",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: _qty > 0 ? Colors.green : Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Tombol checkout
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _qty > 0
                          ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CheckoutPage(
                                    cartQuantities: widget.cartQuantities,
                                    onCartUpdate: widget.onCartUpdate,
                                  ),
                                ),
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey[300],
                      ),
                      child: const Text(
                        "Checkout",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

