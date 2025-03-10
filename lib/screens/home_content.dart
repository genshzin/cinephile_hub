import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shimmer/shimmer.dart';

import '../providers/movie_provider.dart';
import '../models/movie_model.dart';
import '../widgets/movie_card.dart';
import 'now_playing_screen.dart';
import 'popular_movies_screen.dart';
import 'top_rated_movies_screen.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({Key? key}) : super(key: key);

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _currentCarouselIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..forward();
    _initData();
  }

  @override 
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _initData() async {
    if (!mounted) return;
    
    try {
      final provider = Provider.of<MovieProvider>(context, listen: false);
      await provider.fetchNowPlayingMovies(forHome: true);
      if (!mounted) return;
      await provider.fetchTrendingMovies(forHome: true);
      if (!mounted) return;
      await provider.fetchPopularMovies(forHome: true);
      if (!mounted) return;
      await provider.fetchTopRatedMovies(forHome: true);
    } catch (e) {
      print('Error initializing data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: _buildNowPlayingSection(),
          ),
          SliverToBoxAdapter(
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.2),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: _controller,
                curve: const Interval(0.2, 0.6, curve: Curves.easeOut),
              )),
              child: FadeTransition(
                opacity: Tween<double>(begin: 0, end: 1).animate(
                  CurvedAnimation(
                    parent: _controller,
                    curve: const Interval(0.2, 0.6, curve: Curves.easeOut),
                  ),
                ),
                child: _buildSection('Trending This Week', MediaQuery.of(context).size.height * 0.35),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.2),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: _controller,
                curve: const Interval(0.3, 0.7, curve: Curves.easeOut),
              )),
              child: FadeTransition(
                opacity: Tween<double>(begin: 0, end: 1).animate(
                  CurvedAnimation(
                    parent: _controller,
                    curve: const Interval(0.3, 0.7, curve: Curves.easeOut),
                  ),
                ),
                child: _buildSection('Popular', MediaQuery.of(context).size.height * 0.35),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.2),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: _controller,
                curve: const Interval(0.4, 0.8, curve: Curves.easeOut),
              )),
              child: FadeTransition(
                opacity: Tween<double>(begin: 0, end: 1).animate(
                  CurvedAnimation(
                    parent: _controller,
                    curve: const Interval(0.4, 0.8, curve: Curves.easeOut),
                  ),
                ),
                child: _buildSection('Top Rated', MediaQuery.of(context).size.height * 0.35),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 50,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 16),
               
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 80), 
          ),
        ],
      ),
    );
  }

  Widget _buildNowPlayingSection() {
    return Consumer<MovieProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && provider.homeNowPlayingMovies.isEmpty) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: _buildShimmerLoading(),
          );
        }

        if (provider.error.isNotEmpty && provider.homeNowPlayingMovies.isEmpty) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      provider.error,
                      style: TextStyle(color: Colors.red[300]),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _initData,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.redAccent.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF0D1321),
                    const Color(0xFF0D1321).withOpacity(0.8),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 80, 16, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.movie_filter,
                          color: Colors.white,
                          size: 28,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Now Playing',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: TextButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NowPlayingScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                        label: const Text(
                          'See All',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                CarouselSlider(
                  items: provider.homeNowPlayingMovies.map((movie) {
                    return Hero(
                      tag: 'now_playing_${movie.id}',
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 15,
                              spreadRadius: 5,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: MovieCard(movie: movie),
                        ),
                      ),
                    );
                  }).toList(),
                  options: CarouselOptions(
                    height: MediaQuery.of(context).size.height * 0.55,
                    viewportFraction: 0.75,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: true,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 5),
                    autoPlayAnimationDuration: const Duration(milliseconds: 1000),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeStrategy: CenterPageEnlargeStrategy.height,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentCarouselIndex = index;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: provider.homeNowPlayingMovies.asMap().entries.map((entry) {
                    return Container(
                      width: 8.0,
                      height: 8.0,
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(
                          _currentCarouselIndex == entry.key ? 0.9 : 0.3,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: Container(
                height: 5,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[900]!,
      highlightColor: Colors.grey[800]!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 80, 16, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 150,
                  height: 24,
                  color: Colors.white,
                ),
                Container(
                  width: 80,
                  height: 24,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          Center(
            child: Container(
              margin: const EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width * 0.7,
              height: MediaQuery.of(context).size.height * 0.45,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, double height) {
    IconData sectionIcon;
    Color sectionColor;
    
    switch (title) {
      case 'Trending This Week':
        sectionIcon = Icons.trending_up;
        sectionColor = Colors.white;
        break;
      case 'Popular':
        sectionIcon = Icons.favorite;
        sectionColor = Colors.white;
        break;
      case 'Top Rated':
        sectionIcon = Icons.star;
        sectionColor = Colors.white;
        break;
      default:
        sectionIcon = Icons.movie;
        sectionColor = Colors.white;
    }

    Widget buildContent(List<Movie> movies) {
      final limitedMovies = movies.take(10).toList();
      
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              sectionColor.withOpacity(0.05),
              Colors.transparent,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          sectionColor.withOpacity(0.2),
                          Colors.transparent,
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          sectionIcon,
                          color: sectionColor,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.5),
                                offset: const Offset(1, 1),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  title != 'Trending This Week' ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: sectionColor.withOpacity(0.5),
                        width: 1,
                      ),
                    ),
                    child: TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => title == 'Popular' 
                              ? const PopularMoviesScreen()
                              : const TopRatedMoviesScreen(),
                          ),
                        );
                      },
                      icon: Icon(Icons.arrow_forward, size: 20, color: sectionColor),
                      label: Text('See All', style: TextStyle(color: sectionColor)),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      ),
                    ),
                  ) : const SizedBox.shrink(),
                ],
              ),
            ),
            SizedBox(
              height: height,
              child: movies.isEmpty
                  ? _buildSectionShimmer()
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            ...List.generate(limitedMovies.length, (index) {
                              final movie = limitedMovies[index];
                              return AnimatedBuilder(
                                animation: _controller,
                                builder: (context, child) {
                                  final delay = 0.1 * index;
                                  final animationValue = _controller.value > delay
                                      ? (_controller.value - delay) / (1 - delay)
                                      : 0.0;
                                  final opacity = animationValue.clamp(0.0, 1.0);
                                  final translation = (1 - animationValue).clamp(0.0, 1.0) * 20;
                                  
                                  return Opacity(
                                    opacity: opacity,
                                    child: Transform.translate(
                                      offset: Offset(0, translation),
                                      child: child,
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: EdgeInsets.only(right: 16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 10,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: AspectRatio(
                                      aspectRatio: 2 / 3,
                                      child: MovieCard(movie: movie),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
            ),
            Center(
              child: Container(
                height: 2,
                width: 120,
                margin: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      sectionColor.withOpacity(0.3),
                      sectionColor.withOpacity(0.3),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.2, 0.8, 1.0],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (title == 'Trending This Week') {
      return Consumer<MovieProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.homeTrendingMovies.isEmpty) {
            return const SizedBox(
              height: 200,
              child: Center(child: CircularProgressIndicator()),
            );
          }
          return buildContent(provider.homeTrendingMovies);
        },
      );
    } else if (title == 'Popular') {
      return Consumer<MovieProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.homePopularMovies.isEmpty) {
            return const SizedBox(
              height: 200,
              child: Center(child: CircularProgressIndicator()),
            );
          }
          return buildContent(provider.homePopularMovies);
        },
      );
    } else if (title == 'Top Rated') {
      return Consumer<MovieProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.homeTopRatedMovies.isEmpty) {
            return const SizedBox(
              height: 200,
              child: Center(child: CircularProgressIndicator()),
            );
          }
          return buildContent(provider.homeTopRatedMovies);
        },
      );
    }
    
    return const SizedBox.shrink();
  }

  Widget _buildSectionShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[900]!,
      highlightColor: Colors.grey[800]!,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const ClampingScrollPhysics(),
        child: Row(
          children: List.generate(5, (index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.3,
                height: MediaQuery.of(context).size.width * 0.45,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
