import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/app_bar.dart';

class AboutMeScreen extends StatelessWidget {
  final bool fromBottomNav;
  
  const AboutMeScreen({super.key, this.fromBottomNav = false});

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1321),
      extendBodyBehindAppBar: true,
      appBar: fromBottomNav ? null : const CustomAppBar(title: 'About Me'),
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
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              16, 
              fromBottomNav ? 16 + MediaQuery.of(context).padding.top : 90, 
              16, 
              fromBottomNav ? 80 : 16 
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 10,
                      ),
                    ],
                    border: Border.all(
                      color: Colors.white,
                      width: 3,
                    ),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/profile.jpg',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[800],
                          child: const Icon(
                            Icons.person,
                            size: 80,
                            color: Colors.white70,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Nasha Zahira',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Nasha',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 32),
                
                _buildSectionTitle('About Me'),
                const SizedBox(height: 12),
                const Text(
                  'I am a passionate movie enthusiast and compsci student. '
                  'I created this app as part of an assignment for Ristek, '
                  'which happens to align with my love for cinema. When I\'m not watching movies, '
                  'I enjoy reading books, scrolling twitter, and playing Mobile Legends.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                
                _buildSectionTitle('My Hobbies'),
                const SizedBox(height: 16),
                _buildHobbiesRow(),
                const SizedBox(height: 32),
                
                _buildSectionTitle('Favorite Movies'),
                const SizedBox(height: 12),
                _buildFavoriteMoviesList(),
                const SizedBox(height: 32),

                _buildSectionTitle('Social Media'),
                const SizedBox(height: 16),
                _buildSocialMediaLinks(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return OutlinedButton(
      onPressed: null,
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: BorderSide(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.white.withOpacity(0.1),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildHobbiesRow() {
    final hobbies = [
      {'icon': Icons.movie, 'name': 'Movies'},
      {'icon': Icons.book, 'name': 'Books'},
      {'icon': Icons.games, 'name': 'Games'},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: hobbies.map((hobby) {
        return Column(
          children: [
            OutlinedButton(
              onPressed: null,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: BorderSide(color: Colors.white),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                minimumSize: const Size(60, 60),
                padding: EdgeInsets.zero,
              ),
              child: Icon(
                hobby['icon'] as IconData,
                color: Colors.white,
                size: 30,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              hobby['name'] as String,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildFavoriteMoviesList() {
    final movies = [
      'Fallen Angels',
      'In the Mood for Love',
      'Interstellar',
      'Look back',
    ];

    return Column(
      children: movies.map((movie) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: OutlinedButton(
            onPressed: null,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white70,
              side: BorderSide(color: Colors.white.withOpacity(0.5)),
              alignment: Alignment.centerLeft,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            ),
            child: Row(
              children: [
                const Icon(Icons.favorite, color: Colors.red, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    movie,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSocialMediaLinks() {
    final socialMedia = [   
      {
        'icon': Icons.camera_alt,
        'name': 'Instagram',
        'url': 'https://www.instagram.com/nashazhrr?igsh=MTRweTgwY3BudHNmcQ%3D%3D&utm_source=qr',
        'color': Colors.white,
      },
      {
        'icon': Icons.code,
        'name': 'GitHub',
        'url': 'https://github.com/genshzin',
        'color': Colors.white,
      },
    ];

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 20,
      runSpacing: 20,
      children: socialMedia.map((platform) {
        return GestureDetector(
          onTap: () => _launchUrl(platform['url'] as String),
          child: Column(
            children: [
              OutlinedButton(
                onPressed: () => _launchUrl(platform['url'] as String),
                style: OutlinedButton.styleFrom(
                  foregroundColor: platform['color'] as Color?,
                  side: BorderSide(color: (platform['color'] as Color?) ?? Colors.white),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  minimumSize: const Size(60, 60),
                ),
                child: Icon(
                  platform['icon'] as IconData,
                  size: 30,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                platform['name'] as String,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
