import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';
import '../widgets/movie_card.dart';
import '../widgets/app_bar.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:ui';

class NowPlayingScreen extends StatefulWidget {
  const NowPlayingScreen({super.key});

  @override
  State<NowPlayingScreen> createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen> with SingleTickerProviderStateMixin {
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
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildShimmerItem() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[900]!,
      highlightColor: Colors.grey[800]!,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1321),
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(
        title: 'Now Playing',
        
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
            if (provider.isLoading && provider.nowPlayingMovies.isEmpty) {
              return GridView.builder(
                padding: const EdgeInsets.fromLTRB(16, 80, 16, 16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: 10,
                itemBuilder: (context, index) => _buildShimmerItem(),
              );
            }
            
            return RefreshIndicator(
              onRefresh: () => provider.fetchNowPlayingMovies(refresh: true),
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
                itemCount: provider.nowPlayingMovies.length + (provider.hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == provider.nowPlayingMovies.length) {
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
                        movie: provider.nowPlayingMovies[index],
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
      bottomNavigationBar: Container(
        height: 1,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.1),
              blurRadius: 5,
              spreadRadius: 1,
            )
          ],
        ),
      ),
    );
  }
}
