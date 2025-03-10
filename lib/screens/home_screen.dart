import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/drawer.dart';
import '../widgets/movie_card.dart';
import '../providers/movie_provider.dart';
import 'now_playing_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'popular_movies_screen.dart';
import 'top_rated_movies_screen.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _initData();
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
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'CineHub',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      drawer: const CustomDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _buildNowPlayingSection(),
          ),
          SliverToBoxAdapter(
            child: _buildSection('Trending This Week', 180.0),
          ),
          SliverToBoxAdapter(
            child: _buildSection('Popular', 200.0),
          ),
          SliverToBoxAdapter(
            child: _buildSection('Top Rated', 180.0),
          ),
        ],
      ),
    );
  }

  Widget _buildNowPlayingSection() {
    return Consumer<MovieProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && provider.homeNowPlayingMovies.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.error.isNotEmpty && provider.homeNowPlayingMovies.isEmpty) {
          return Center(child: Text(provider.error));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Now Playing',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NowPlayingScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'See All',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
            CarouselSlider(
              items: provider.homeNowPlayingMovies.map((movie) => 
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: MovieCard(movie: movie),
                  ),
                ),
              ).toList(),
              options: CarouselOptions(
                height: 400,
                aspectRatio: 2/3, // Better aspect ratio for movie posters
                viewportFraction: 0.55,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                enlargeFactor: 0.2,
                scrollDirection: Axis.horizontal,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSection(String title, double height) {
    if (title == 'Trending This Week') {
      return Consumer<MovieProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.homeTrendingMovies.isEmpty) {
            return const SizedBox(
              height: 200,
              child: Center(child: CircularProgressIndicator()),
            );
          }

          if (provider.error.isNotEmpty && provider.homeTrendingMovies.isEmpty) {
            return SizedBox(
              height: 200,
              child: Center(child: Text(provider.error, style: const TextStyle(color: Colors.white))),
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
              CarouselSlider(
                items: provider.homeTrendingMovies.map((movie) => 
                  Container(
                    width: 130,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: MovieCard(movie: movie),
                    ),
                  ),
                ).toList(),
                options: CarouselOptions(
                  height: height,
                  viewportFraction: 0.3,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  enlargeCenterPage: false,
                  scrollDirection: Axis.horizontal,
                ),
              ),
            ],
          );
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

          if (provider.error.isNotEmpty && provider.homePopularMovies.isEmpty) {
            return SizedBox(
              height: 200,
              child: Center(child: Text(provider.error, style: const TextStyle(color: Colors.white))),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PopularMoviesScreen(),
                          ),
                        );
                      },
                      child: const Text('See All', style: TextStyle(color: Colors.blue)),
                    ),
                  ],
                ),
              ),
              CarouselSlider(
                items: provider.homePopularMovies.map((movie) => 
                  Container(
                    width: 130,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: MovieCard(movie: movie),
                    ),
                  ),
                ).toList(),
                options: CarouselOptions(
                  height: height,
                  viewportFraction: 0.3,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  enlargeCenterPage: false,
                  scrollDirection: Axis.horizontal,
                ),
              ),
            ],
          );
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

          if (provider.error.isNotEmpty && provider.homeTopRatedMovies.isEmpty) {
            return SizedBox(
              height: 200,
              child: Center(child: Text(provider.error, style: const TextStyle(color: Colors.white))),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TopRatedMoviesScreen(),
                          ),
                        );
                      },
                      child: const Text('See All', style: TextStyle(color: Colors.blue)),
                    ),
                  ],
                ),
              ),
              CarouselSlider(
                items: provider.homeTopRatedMovies.map((movie) => 
                  Container(
                    width: 130,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: MovieCard(movie: movie),
                    ),
                  ),
                ).toList(),
                options: CarouselOptions(
                  height: height,
                  viewportFraction: 0.3,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  enlargeCenterPage: false,
                  scrollDirection: Axis.horizontal,
                ),
              ),
            ],
          );
        },
      );
    }

    // Return the original placeholder widget for other sections
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
          height: height,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 10,
            itemBuilder: (context, index) {
              return Container(
                width: 130,
                margin: const EdgeInsets.only(left: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[850],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Icon(
                    Icons.movie_outlined,
                    color: Colors.grey[400],
                    size: 40,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}