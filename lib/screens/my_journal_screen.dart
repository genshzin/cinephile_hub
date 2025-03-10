import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/movie_model.dart';
import '../models/journal_entry.dart';
import '../providers/journal_provider.dart';
import 'movie_detail_screen.dart';

class MyJournalScreen extends StatelessWidget {
  const MyJournalScreen({super.key});

  Widget _buildSection(String title, List<Widget> items) {
    if (items.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'No movies in this section yet',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      );
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: items,
          ),
        ),
      ],
    );
  }

  Widget _buildMovieCard(BuildContext context, Movie movie, JournalEntry journal) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MovieDetailScreen(movie: movie),
        ),
      ),
      child: Container(
        width: 120,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                movie.fullPosterPath,
                height: 150,
                width: 120,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              movie.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final journalProvider = Provider.of<JournalProvider>(context);
    
    // Add debug print
    print('Journal entries: ${journalProvider.entries.length}');
    
    final reviewedMovies = journalProvider
        .getEntriesByType('review')
        .map((entry) => _buildMovieCard(context, entry.movie, entry))
        .toList();
        
    final watchedMovies = journalProvider
        .getEntriesByType('watch')
        .map((entry) => _buildMovieCard(context, entry.movie, entry))
        .toList();
        
    final likedMovies = journalProvider
        .getEntriesByType('like')
        .map((entry) => _buildMovieCard(context, entry.movie, entry))
        .toList();

    return Scaffold(
      key: const Key('my_journal_screen'), // Add key for debugging
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('My Journal'),
        backgroundColor: Colors.black,
      ),
      body: ListView(
        children: [
          _buildSection('Reviewed Movies', reviewedMovies),
          _buildSection('Watched Movies', watchedMovies),
          _buildSection('Liked Movies', likedMovies),
        ],
      ),
    );
  }
}
