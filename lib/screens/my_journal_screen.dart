import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/movie_model.dart';
import '../models/journal_entry.dart';
import '../providers/journal_provider.dart';
import 'movie_detail_screen.dart';
import '../widgets/app_bar.dart';

class MyJournalScreen extends StatelessWidget {
  final bool fromBottomNav;

  const MyJournalScreen({super.key, this.fromBottomNav = false});

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
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Icon(
                    Icons.movie_filter_outlined,
                    size: 48,
                    color: Colors.white30,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'No movies in this section yet',
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(color: Colors.white12),
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
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ),
        SizedBox(
          height: 240,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: items,
          ),
        ),
        const Divider(color: Colors.white12, height: 32),
      ],
    );
  }

  Widget _buildMovieCard(BuildContext context, Movie movie, JournalEntry journal) {
    return Hero(
      tag: 'journal-movie-${movie.id}',
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetailScreen(movie: movie),
          ),
        ),
        child: Container(
          width: 140,
          margin: const EdgeInsets.only(right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 180,
                width: 140,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    movie.fullPosterPath,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: const Color(0xFF1A1A1A),
                        child: const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white54),
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xFF1A1A1A),
                        child: const Center(
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            color: Colors.white54,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                movie.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (journal.rating != null && journal.rating! > 0) ...[
                const SizedBox(height: 4),
                Row(
                  children: List.generate(
                    5,
                    (index) => Icon(
                      index < journal.rating!.toInt() ? Icons.star : Icons.star_border,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final journalProvider = Provider.of<JournalProvider>(context);
    
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
      key: const Key('my_journal_screen'),
      extendBodyBehindAppBar: true,
      appBar: fromBottomNav ? null : const CustomAppBar(
        title: 'My Journal',
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF0D1321),
              Colors.black.withOpacity(0.8),
            ],
          ),
        ),
        child: ListView(
          padding: EdgeInsets.only(
            top: fromBottomNav ? 16 + MediaQuery.of(context).padding.top : 80,
            bottom: fromBottomNav ? 80 : 16, 
          ),
          children: [
            _buildSection('Reviewed Movies', reviewedMovies),
            _buildSection('Watched Movies', watchedMovies),
            _buildSection('Liked Movies', likedMovies),
          ],
        ),
      ),
    );
  }
}
