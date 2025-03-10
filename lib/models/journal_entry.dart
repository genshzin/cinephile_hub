import 'movie_model.dart';

class JournalEntry {
  final Movie movie;
  final double? rating;
  final String content;
  final DateTime dateTime;
  final String type; 

  JournalEntry({
    required this.movie,
    this.rating,
    required this.content,
    required this.dateTime,
    required this.type,
  });


  String get formattedDate => dateTime.toString().split('.')[0];

  
  bool get isEditable => type == 'review';

  String get formattedContent {
    if (type == 'review') return content;
    
    String action = '';
    switch (type) {
      case 'watch':
        action = 'Watched';
        break;
      case 'like':
        action = 'Liked';
        break;
      case 'bookmark':
        action = 'Bookmarked';
        break;
      default:
        return content;
    }
    
    return '$action this movie on ${_formatDate(dateTime)}';
  }

  String _formatDate(DateTime date) {
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  Map<String, dynamic> toJson() {
    return {
      'movie': movie.toJson(),
      'content': content,
      'rating': rating,
      'dateTime': dateTime.toIso8601String(),
      'type': type,
    };
  }

  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    return JournalEntry(
      movie: Movie.fromJson(json['movie']),
      content: json['content'],
      rating: json['rating']?.toDouble(),
      dateTime: DateTime.parse(json['dateTime']),
      type: json['type'],
    );
  }
}
