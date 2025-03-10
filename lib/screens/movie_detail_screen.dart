import 'package:flutter/material.dart';
import 'dart:ui';
import '../models/movie_model.dart';
import '../models/journal_entry.dart';
import 'package:provider/provider.dart';
import '../providers/journal_provider.dart';
import '../providers/bookmark_provider.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;
  const MovieDetailScreen({super.key, required this.movie});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  int _rating = 0;
  final _reviewController = TextEditingController();

  void _addActionJournal(String type) {
    final journalProvider = Provider.of<JournalProvider>(context, listen: false);
    journalProvider.addEntry(JournalEntry(
      movie: widget.movie,
      content: '',
      dateTime: DateTime.now(),
      type: type,
    ));
  }

  void _editJournal(int index) {
    final journalProvider = Provider.of<JournalProvider>(context, listen: false);
    final journal = journalProvider.entries[index];
    int tempRating = journal.rating?.toInt() ?? 0;
    final reviewController = TextEditingController(text: journal.content);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Edit Journal Entry',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (journal.type == 'review') ...[
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return GestureDetector(
                        onTap: () {
                          setModalState(() {
                            tempRating = index + 1;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Icon(
                            index < tempRating ? Icons.star : Icons.star_border,
                            color: index < tempRating ? Colors.amber : Colors.white,
                            size: 36,
                          ),
                        ),
                      );
                    }),
                  ),
                ],
                const SizedBox(height: 16),
                TextField(
                  controller: reviewController,
                  style: const TextStyle(color: Colors.white),
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Write your thoughts...',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.white30),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.white30),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[800],
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (reviewController.text.trim().isNotEmpty) {
                            setState(() {
                              final updatedEntry = JournalEntry(
                                movie: journal.movie,
                                rating: journal.type == 'review' ? tempRating.toDouble() : null,
                                content: reviewController.text.trim(),
                                dateTime: DateTime.now(),
                                type: journal.type,
                              );
                              journalProvider.updateEntry(journal, updatedEntry);
                            });
                            Navigator.pop(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                        ),
                        child: const Text('Save'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showJournalModal() {
    int tempRating = 0;
    final reviewController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add Journal Entry',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return GestureDetector(
                      onTap: () {
                        setModalState(() {
                          tempRating = index + 1;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(
                          index < tempRating ? Icons.star : Icons.star_border,
                          color: index < tempRating ? Colors.amber : Colors.white,
                          size: 36,
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: reviewController,
                  style: const TextStyle(color: Colors.white),
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Write your thoughts... (optional)',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.white30),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.white30),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (tempRating > 0 || reviewController.text.trim().isNotEmpty) {
                        setState(() {
                          final journalProvider = Provider.of<JournalProvider>(context, listen: false);
                          journalProvider.addEntry(JournalEntry(
                            movie: widget.movie,
                            rating: tempRating > 0 ? tempRating.toDouble() : null,
                            content: reviewController.text.trim(),
                            dateTime: DateTime.now(),
                            type: 'review',
                          ));
                        });
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Save Journal'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildJournalList() {
    return Consumer<JournalProvider>(
      builder: (context, journalProvider, child) {
        final movieJournals = journalProvider.entries
            .where((entry) => entry.movie.id == widget.movie.id)
            .toList();

        if (movieJournals.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Your Journal',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ...movieJournals.asMap().entries.map((entry) {
              final index = entry.key;
              final journal = entry.value;
              final hasRating = journal.rating != null && journal.rating! > 0;
              final hasContent = journal.content.isNotEmpty;

              return Card(
                color: Colors.black45,
                margin: const EdgeInsets.only(bottom: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              journal.type == 'like' 
                                ? 'Liked this movie on ${journal.formattedDate}'
                                : journal.type == 'watch'
                                  ? 'Watched this movie on ${journal.formattedDate}'
                                  : journal.type == 'bookmark'
                                    ? 'Added to "${Provider.of<BookmarkProvider>(context).getListNameForMovie(widget.movie)}" on ${journal.formattedDate}'
                                    : journal.type == 'review'
                                      ? hasRating && hasContent
                                        ? 'Reviewed and rated this movie on ${journal.formattedDate}'
                                        : hasRating
                                          ? 'Rated this movie on ${journal.formattedDate}'
                                          : 'Reviewed this movie on ${journal.formattedDate}'
                                      : journal.formattedDate,
                              style: const TextStyle(
                                color: Colors.white60,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          if (journal.type == 'review') ...[
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.white60, size: 16),
                              onPressed: () => _editJournal(index),
                            ),
                          ],
                          if (journal.type != 'bookmark') ...[
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.white60, size: 16),
                              onPressed: () {
                                setState(() => journalProvider.removeEntry(journal));
                              },
                            ),
                          ],
                        ],
                      ),
                      if (journal.type == 'review') ...[
                        if (hasRating) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: List.generate(5, (index) => Icon(
                              index < (journal.rating ?? 0) ? Icons.star : Icons.star_border,
                              color: Colors.amber,
                              size: 16,
                            )),
                          ),
                        ],
                        if (hasContent) ...[
                          const SizedBox(height: 8),
                          Text(
                            journal.formattedContent,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ],
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        );
      },
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required IconData filledIcon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
    Color? activeColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(
            isActive ? filledIcon : icon,
            color: isActive ? (activeColor ?? Colors.white) : Colors.white,
            size: 28,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingStars() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              _rating = index + 1;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Icon(
              index < _rating ? Icons.star : Icons.star_border,
              color: index < _rating ? Colors.amber : Colors.white,
              size: 36,
            ),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final journalProvider = Provider.of<JournalProvider>(context);
    final isWatched = journalProvider.hasEntryForMovie(widget.movie, 'watch');
    final isLiked = journalProvider.hasEntryForMovie(widget.movie, 'like');
    final isBookmarked = journalProvider.hasEntryForMovie(widget.movie, 'bookmark');

    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.width * 9 / 16,
            pinned: true,
            backgroundColor: Colors.transparent,
            leading: CircleAvatar(
              backgroundColor: Colors.black38,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                return FlexibleSpaceBar(
                  centerTitle: true,
                  title: AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: constraints.biggest.height <= kToolbarHeight * 1.5 ? 1 : 0,
                    child: Text(
                      widget.movie.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Hero(
                        tag: 'movie-backdrop-${widget.movie.id}',
                        child: Image.network(
                          widget.movie.fullBackdropPath,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.8),
                              Colors.black,
                            ],
                            stops: const [0.0, 0.7, 1.0],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.movie.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            widget.movie.voteAverage.toStringAsFixed(1),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),
                      Text(
                        widget.movie.releaseDate.split('-')[0], 
                        style: const TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                      const SizedBox(width: 20),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white30),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          widget.movie.originalLanguage.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    widget.movie.overview,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildActionButton(
                        icon: Icons.check_circle_outline,
                        filledIcon: Icons.check_circle,
                        label: 'Watch',
                        isActive: isWatched,
                        onTap: () {
                          final journalProvider = Provider.of<JournalProvider>(context, listen: false);
                          if (isWatched) {
                            journalProvider.removeEntryByMovieAndType(widget.movie, 'watch');
                          } else {
                            _addActionJournal('watch');
                          }
                        },
                      ),
                      _buildActionButton(
                        icon: Icons.favorite_outline,
                        filledIcon: Icons.favorite,
                        label: 'Like',
                        isActive: isLiked,
                        onTap: () {
                          final journalProvider = Provider.of<JournalProvider>(context, listen: false);
                          if (isLiked) {
                            journalProvider.removeEntryByMovieAndType(widget.movie, 'like');
                          } else {
                            _addActionJournal('like');
                          }
                        },
                        activeColor: Colors.red,
                      ),
                      _buildActionButton(
                        icon: Icons.bookmark_outline,
                        filledIcon: Icons.bookmark,
                        label: 'Bookmark',
                        isActive: isBookmarked,
                        onTap: () {
                          final bookmarkProvider = Provider.of<BookmarkProvider>(context, listen: false);
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.black,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                            ),
                            builder: (context) => Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Text(
                                    'Add to List',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: bookmarkProvider.lists.length,
                                    itemBuilder: (context, index) {
                                      final list = bookmarkProvider.lists[index];
                                      final isInList = bookmarkProvider.isMovieInList(widget.movie, list);
                                      return ListTile(
                                        title: Text(
                                          list.name,
                                          style: const TextStyle(color: Colors.white),
                                        ),
                                        trailing: Icon(
                                          isInList ? Icons.check : Icons.add,
                                          color: Colors.white,
                                        ),
                                        onTap: () {
                                          if (isInList) {
                                            bookmarkProvider.removeMovieFromList(widget.movie, list);
                                            journalProvider.removeEntryByMovieAndType(widget.movie, 'bookmark');
                                          } else {
                                            bookmarkProvider.addMovieToList(widget.movie, list);
                                            _addActionJournal('bookmark');
                                          }
                                          Navigator.pop(context);
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      _buildActionButton(
                        icon: Icons.edit_note,
                        filledIcon: Icons.edit_note,
                        label: 'Journal',
                        isActive: false,
                        onTap: _showJournalModal,
                      ),
                    ],
                  ),
                  _buildJournalList(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }
}
