import 'package:flutter/material.dart';
import '../models/movie_model.dart';
import '../services/api_service.dart';

class MovieProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Movie> _nowPlayingMovies = [];
  List<Movie> _homeNowPlayingMovies = [];
  List<Movie> _popularMovies = [];
  List<Movie> _homePopularMovies = [];
  List<Movie> _topRatedMovies = [];
  List<Movie> _homeTopRatedMovies = [];
  List<Movie> _trendingMovies = [];
  List<Movie> _homeTrendingMovies = [];
  bool _isLoading = false;
  String _error = '';
  int _currentPage = 1;
  int _totalPages = 1;
  bool _hasMore = true;
  int _popularCurrentPage = 1;
  int _popularTotalPages = 1;
  bool _hasMorePopular = true;
  int _topRatedCurrentPage = 1;
  int _topRatedTotalPages = 1;
  bool _hasMoreTopRated = true;
  int _trendingCurrentPage = 1;
  int _trendingTotalPages = 1;
  bool _hasMoreTrending = true;

  List<Movie> get nowPlayingMovies => _nowPlayingMovies;
  List<Movie> get homeNowPlayingMovies => _homeNowPlayingMovies;
  List<Movie> get popularMovies => _popularMovies;
  List<Movie> get homePopularMovies => _homePopularMovies;
  List<Movie> get topRatedMovies => _topRatedMovies;
  List<Movie> get homeTopRatedMovies => _homeTopRatedMovies;
  List<Movie> get trendingMovies => _trendingMovies;
  List<Movie> get homeTrendingMovies => _homeTrendingMovies;
  bool get isLoading => _isLoading;
  String get error => _error;
  bool get hasMore => _hasMore;
  bool get hasMorePopular => _hasMorePopular;
  bool get hasMoreTopRated => _hasMoreTopRated;
  bool get hasMoreTrending => _hasMoreTrending;

  Future<void> fetchNowPlayingMovies({bool refresh = false, bool forHome = false}) async {
    if (forHome) {
      _isLoading = true;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
      
      try {
        final result = await _apiService.getNowPlayingMovies(page: 1);
        _homeNowPlayingMovies = result['movies'];
      } catch (e) {
        _error = e.toString();
      } finally {
        _isLoading = false;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          notifyListeners();
        });
      }
      return;
    }

    if (refresh) {
      _currentPage = 1;
      _nowPlayingMovies = [];
      _hasMore = true;
    }

    if (_isLoading || !_hasMore) return;

    _isLoading = true;
    if (!refresh) notifyListeners();

    try {
      final result = await _apiService.getNowPlayingMovies(page: _currentPage);
      final List<Movie> movies = result['movies'];
      _totalPages = result['totalPages'];
      
      if (refresh) {
        _nowPlayingMovies = movies;
      } else {
        _nowPlayingMovies.addAll(movies);
      }
      
      _currentPage++;
      _hasMore = _currentPage <= _totalPages;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchPopularMovies({bool refresh = false, bool forHome = false}) async {
    if (forHome) {
      _isLoading = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners(); 
      });
      
      try {
        final result = await _apiService.getPopularMovies(page: 1);
        _homePopularMovies = result['movies'];
      } catch (e) {
        _error = e.toString();
      } finally {
        _isLoading = false;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          notifyListeners();
        });
      }
      return;
    }

    if (refresh) {
      _popularCurrentPage = 1;
      _popularMovies = [];
      _hasMorePopular = true;
    }

    if (_isLoading || !_hasMorePopular) return;

    _isLoading = true;
    if (!refresh) notifyListeners();

    try {
      final result = await _apiService.getPopularMovies(page: _popularCurrentPage);
      final List<Movie> movies = result['movies'];
      _popularTotalPages = result['totalPages'];
      
      if (refresh) {
        _popularMovies = movies;
      } else {
        _popularMovies.addAll(movies);
      }
      
      _popularCurrentPage++;
      _hasMorePopular = _popularCurrentPage <= _popularTotalPages;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchTopRatedMovies({bool refresh = false, bool forHome = false}) async {
    if (forHome) {
      _isLoading = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
      
      try {
        final result = await _apiService.getTopRatedMovies(page: 1);
        _homeTopRatedMovies = result['movies'];
      } catch (e) {
        _error = e.toString();
      } finally {
        _isLoading = false;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          notifyListeners();
        });
      }
      return;
    }

    if (refresh) {
      _topRatedCurrentPage = 1;
      _topRatedMovies = [];
      _hasMoreTopRated = true;
    }

    if (_isLoading || !_hasMoreTopRated) return;

    _isLoading = true;
    if (!refresh) notifyListeners();

    try {
      final result = await _apiService.getTopRatedMovies(page: _topRatedCurrentPage);
      final List<Movie> movies = result['movies'];
      _topRatedTotalPages = result['totalPages'];
      
      if (refresh) {
        _topRatedMovies = movies;
      } else {
        _topRatedMovies.addAll(movies);
      }
      
      _topRatedCurrentPage++;
      _hasMoreTopRated = _topRatedCurrentPage <= _topRatedTotalPages;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchTrendingMovies({bool refresh = false, bool forHome = false}) async {
    if (forHome) {
      _isLoading = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
      
      try {
        final result = await _apiService.getTrendingMovies(page: 1);
        _homeTrendingMovies = result['movies'];
      } catch (e) {
        _error = e.toString(); 
      } finally {
        _isLoading = false;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          notifyListeners();
        });
      }
      return;
    }

    if (refresh) {
      _trendingCurrentPage = 1;
      _trendingMovies = [];
      _hasMoreTrending = true;
    }

    if (_isLoading || !_hasMoreTrending) return;

    _isLoading = true;
    if (!refresh) notifyListeners();

    try {
      final result = await _apiService.getTrendingMovies(page: _trendingCurrentPage);
      final List<Movie> movies = result['movies'];
      _trendingTotalPages = result['totalPages'];
      
      if (refresh) {
        _trendingMovies = movies;
      } else {
        _trendingMovies.addAll(movies);
      }
      
      _trendingCurrentPage++;
      _hasMoreTrending = _trendingCurrentPage <= _trendingTotalPages;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
