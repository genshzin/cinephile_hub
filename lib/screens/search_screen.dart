import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';
import '../widgets/movie_card.dart';
import '../widgets/app_bar.dart';

class SearchScreen extends StatefulWidget {
  final bool fromBottomNav;
  
  const SearchScreen({super.key, this.fromBottomNav = false});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      final provider = Provider.of<MovieProvider>(context, listen: false);
      if (!provider.isLoading && provider.hasMoreSearch) {
        provider.searchMovies(_searchController.text);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: widget.fromBottomNav ? null : CustomAppBar(
        title: 'Search Movies',
        automaticallyImplyLeading: true,
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
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                16.0, 
                widget.fromBottomNav ? 16.0 + MediaQuery.of(context).padding.top : 80.0, 
                16.0, 
                16.0
              ),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search movies...',
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.grey[900],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear, color: Colors.grey),
                    onPressed: () {
                      _searchController.clear();
                      Provider.of<MovieProvider>(context, listen: false)
                          .searchMovies('', refresh: true);
                    },
                  ),
                ),
                onChanged: (value) {
                  Provider.of<MovieProvider>(context, listen: false)
                      .searchMovies(value, refresh: true);
                },
              ),
            ),
            Expanded(
              child: Consumer<MovieProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading && provider.searchResults.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (provider.searchResults.isEmpty) {
                    return const Center(
                      child: Text(
                        'No results found',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  return GridView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.fromLTRB(
                      16, 
                      16, 
                      16, 
                      widget.fromBottomNav ? 80 : 16 
                    ),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 2/3,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: provider.searchResults.length,
                    itemBuilder: (context, index) {
                      final movie = provider.searchResults[index];
                      return MovieCard(movie: movie);
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
