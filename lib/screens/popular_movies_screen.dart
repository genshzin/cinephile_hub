import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';
import '../widgets/movie_card.dart';
import '../widgets/app_bar.dart';

class PopularMoviesScreen extends StatefulWidget {
  const PopularMoviesScreen({super.key});

  @override
  State<PopularMoviesScreen> createState() => _PopularMoviesScreenState();
}

class _PopularMoviesScreenState extends State<PopularMoviesScreen> with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
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
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1321),
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(
        title: 'Popular Movies',
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
        child: Consumer<MovieProvider>(
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
              color: Colors.white,
              backgroundColor: Colors.black,
              child: GridView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(16, 80, 16, 16),
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: provider.popularMovies.length + (provider.hasMorePopular ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == provider.popularMovies.length) {
                    return Center(
                      child: Container(
                        width: 40,
                        height: 40,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black45,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    );
                  }
                  
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset(0, (index % 2 == 0) ? 0.2 : 0.5),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(
                        parent: _animationController,
                        curve: Interval(
                          index * 0.05,
                          0.4 + index * 0.05,
                          curve: Curves.easeOutQuad,
                        ),
                      ),
                    ),
                    child: FadeTransition(
                      opacity: Tween<double>(begin: 0, end: 1).animate(
                        CurvedAnimation(
                          parent: _animationController,
                          curve: Interval(
                            index * 0.05,
                            0.4 + index * 0.05,
                            curve: Curves.easeOut,
                          ),
                        ),
                      ),
                      child: MovieCard(
                        movie: provider.popularMovies[index],
                        showTitle: true,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
