import 'package:flutter/material.dart';
import '../models/movie_model.dart';
import '../screens/movie_detail_screen.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetailScreen(movie: movie),
          ),
        );
      },
      child: AspectRatio(
        aspectRatio: 2/3,
        child: Image.network(
          movie.fullPosterPath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[850],
              child: const Icon(
                Icons.movie_outlined,
                color: Colors.white54,
                size: 40,
              ),
            );
          },
        ),
      ),
    );
  }
}
