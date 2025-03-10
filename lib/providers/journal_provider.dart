import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import '../models/movie_model.dart';
import '../models/journal_entry.dart';

class JournalProvider with ChangeNotifier {
  final List<JournalEntry> _entries = [];
  static const String _key = 'journal_entries';

  List<JournalEntry> get entries => _entries;
  
  List<JournalEntry> getEntriesByType(String type) {
    return _entries.where((entry) => entry.type == type).toList();
  }

  Future<void> loadEntries() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? entriesJson = prefs.getString(_key);
      
      if (entriesJson != null) {
        final List<dynamic> decodedList = json.decode(entriesJson);
        _entries.clear();
        _entries.addAll(
          decodedList.map((item) => JournalEntry.fromJson(item)).toList()
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading journal entries: $e');
    }
  }

  Future<void> saveEntries() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final entriesJson = json.encode(
        _entries.map((entry) => entry.toJson()).toList()
      );
      await prefs.setString(_key, entriesJson);
    } catch (e) {
      debugPrint('Error saving journal entries: $e');
    }
  }

  void addEntry(JournalEntry entry) async {
    _entries.insert(0, entry);
    await saveEntries();
    notifyListeners();
  }

  void removeEntry(JournalEntry entry) async {
    _entries.remove(entry);
    await saveEntries();
    notifyListeners();
  }

  void updateEntry(JournalEntry oldEntry, JournalEntry newEntry) async {
    final index = _entries.indexOf(oldEntry);
    if (index != -1) {
      _entries[index] = newEntry;
      await saveEntries();
      notifyListeners();
    }
  }

  bool hasEntryForMovie(Movie movie, String type) {
    return _entries.any((entry) => entry.movie.id == movie.id && entry.type == type);
  }
  
  void removeEntryByMovieAndType(Movie movie, String type) async {
    _entries.removeWhere((entry) => entry.movie.id == movie.id && entry.type == type);
    await saveEntries();
    notifyListeners();
  }
}
