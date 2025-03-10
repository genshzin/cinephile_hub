import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';
import '../widgets/movie_card.dart';

class NowPlayingScreen extends StatefulWidget {
  const NowPlayingScreen({super.key});

  @override
  State<NowPlayingScreen> createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    Future.microtask(
      () => context.read<MovieProvider>().fetchNowPlayingMovies(refresh: true),
    );
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<MovieProvider>().fetchNowPlayingMovies();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Now Playing Movies',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Consumer<MovieProvider>(
        builder: (context, provider, child) {
          return GridView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: provider.nowPlayingMovies.length + (provider.hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == provider.nowPlayingMovies.length) {
                return const Center(child: CircularProgressIndicator());
              }
              return MovieCard(movie: provider.nowPlayingMovies[index]);
            },
          );
        },
      ),
    );
  }
}
