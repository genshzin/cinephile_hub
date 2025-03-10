import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';
import '../widgets/movie_card.dart';

class PopularMoviesScreen extends StatefulWidget {
  const PopularMoviesScreen({super.key});

  @override
  State<PopularMoviesScreen> createState() => _PopularMoviesScreenState();
}

class _PopularMoviesScreenState extends State<PopularMoviesScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _initData();
  }

  Future<void> _initData() async {
    await Provider.of<MovieProvider>(context, listen: false)
        .fetchPopularMovies(refresh: true);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      Provider.of<MovieProvider>(context, listen: false).fetchPopularMovies();
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
        title: const Text('Popular Movies'),
      ),
      body: Consumer<MovieProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.popularMovies.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error.isNotEmpty && provider.popularMovies.isEmpty) {
            return Center(
              child: Text(
                provider.error,
                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => provider.fetchPopularMovies(refresh: true),
            child: GridView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: provider.popularMovies.length + (provider.hasMorePopular ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == provider.popularMovies.length) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: MovieCard(movie: provider.popularMovies[index]),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
