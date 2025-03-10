import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie_model.dart';

class ApiService {
  static const String _baseUrl = 'https://api.themoviedb.org/3';
  static const String _apiKey = '345ccb313d4f7447388f01ed46d7b0b9'; 

  Future<Map<String, dynamic>> getNowPlayingMovies({int page = 1}) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/movie/now_playing?api_key=$_apiKey&page=$page'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<Movie> movies = (data['results'] as List)
            .map((json) => Movie.fromJson(json))
            .toList();
        return {
          'movies': movies,
          'currentPage': data['page'],
          'totalPages': data['total_pages'],
        };
      } else {
        throw Exception('Failed to load now playing movies');
      }
    } catch (e) {
      throw Exception('Error fetching now playing movies: $e');
    }
  }

  Future<Map<String, dynamic>> getPopularMovies({int page = 1}) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/movie/popular?api_key=$_apiKey&page=$page'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<Movie> movies = (data['results'] as List)
            .map((json) => Movie.fromJson(json))
            .toList();
        return {
          'movies': movies,
          'currentPage': data['page'],
          'totalPages': data['total_pages'],
        };
      } else {
        throw Exception('Failed to load popular movies');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getTopRatedMovies({int page = 1}) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/movie/top_rated?api_key=$_apiKey&page=$page'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<Movie> movies = (data['results'] as List)
            .map((json) => Movie.fromJson(json))
            .toList();
        return {
          'movies': movies,
          'currentPage': data['page'],
          'totalPages': data['total_pages'],
        };
      } else {
        throw Exception('Failed to load top rated movies');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getTrendingMovies({int page = 1}) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/trending/movie/week?api_key=$_apiKey&page=$page'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<Movie> movies = (data['results'] as List)
            .map((json) => Movie.fromJson(json))
            .toList();
        return {
          'movies': movies,
          'currentPage': data['page'],
          'totalPages': data['total_pages'],
        };
      } else {
        throw Exception('Failed to load trending movies');
      }
    } catch (e) {
      rethrow;
    }
  }
}
