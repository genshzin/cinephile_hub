import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/movie_model.dart';

class BookmarkList {
  final String name;
  final List<Movie> movies;
  bool isDefault;

  BookmarkList({
    required this.name,
    List<Movie>? movies,
    this.isDefault = false,
  }) : movies = movies ?? [];

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'movies': movies.map((movie) => movie.toJson()).toList(),
      'isDefault': isDefault,
    };
  }

  factory BookmarkList.fromJson(Map<String, dynamic> json) {
    return BookmarkList(
      name: json['name'],
      movies: (json['movies'] as List)
          .map((movieJson) => Movie.fromJson(movieJson))
          .toList(),
      isDefault: json['isDefault'],
    );
  }
}

class BookmarkProvider with ChangeNotifier {
  final List<BookmarkList> _lists = [
    BookmarkList(name: 'My Watchlist', isDefault: true),
  ];

  static const String _key = 'bookmark_lists';

  List<BookmarkList> get lists => _lists;

  Future<void> loadLists() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? listsJson = prefs.getString(_key);
      
      if (listsJson != null) {
        final List<dynamic> decodedList = json.decode(listsJson);
        _lists.clear();
        _lists.addAll(
          decodedList.map((item) => BookmarkList.fromJson(item)).toList()
        );
        
        if (!_lists.any((list) => list.isDefault)) {
          _lists.add(BookmarkList(name: 'My Watchlist', isDefault: true));
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading bookmark lists: $e');
    }
  }

  Future<void> saveLists() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final listsJson = json.encode(
        _lists.map((list) => list.toJson()).toList()
      );
      await prefs.setString(_key, listsJson);
    } catch (e) {
      debugPrint('Error saving bookmark lists: $e');
    }
  }

  void addList(String name) async {
    _lists.add(BookmarkList(name: name));
    await saveLists();
    notifyListeners();
  }

  void addMovieToList(Movie movie, BookmarkList list) async {
    if (!list.movies.contains(movie)) {
      list.movies.add(movie);
      await saveLists();
      notifyListeners();
    }
  }

  void removeMovieFromList(Movie movie, BookmarkList list) async {
    list.movies.remove(movie);
    await saveLists();
    notifyListeners();
  }

  bool isMovieInList(Movie movie, BookmarkList list) {
    return list.movies.contains(movie);
  }

  String getListNameForMovie(Movie movie) {
    for (var list in lists) {
      if (list.movies.any((m) => m.id == movie.id)) {
        return list.name;
      }
    }
    return '';
  }
}
