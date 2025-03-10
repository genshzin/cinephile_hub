import 'package:flutter/material.dart';
import '../widgets/drawer.dart';
import 'dart:ui';
import 'package:cinephile_hub/screens/about_me_screen.dart';
import 'package:cinephile_hub/screens/bookmark_screen.dart';
import 'package:cinephile_hub/screens/my_journal_screen.dart';
import 'package:cinephile_hub/screens/search_screen.dart';
import 'package:cinephile_hub/widgets/crystal_navigation_bar.dart';
import 'home_content.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeContent(),
    const SearchScreen(fromBottomNav: true),
    const MyJournalScreen(fromBottomNav: true),
    const BookmarkScreen(fromBottomNav: true),
    const AboutMeScreen(fromBottomNav: true),
  ];

  final List<CrystalNavigationBarItem> _navItems = [
    CrystalNavigationBarItem(
      icon: IconlyBold.home,
      unselectedIcon: IconlyLight.home,
      selectedColor: Colors.white,
    ),
    CrystalNavigationBarItem(
      icon: IconlyBold.search,
      unselectedIcon: IconlyLight.search,
      selectedColor: Colors.white,
    ),
    CrystalNavigationBarItem(
      icon: IconlyBold.plus,
      unselectedIcon: IconlyLight.add,
      selectedColor: Colors.white,
    ),
    CrystalNavigationBarItem(
      icon: IconlyBold.bookmark,
      unselectedIcon: IconlyLight.bookmark,
      selectedColor: Colors.white,
    ),
    CrystalNavigationBarItem(
      icon: IconlyBold.user_2,
      unselectedIcon: IconlyLight.user,
      selectedColor: Colors.white,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1321),
      extendBodyBehindAppBar: true,
      extendBody: true, 
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.4),
                    Colors.black.withOpacity(0.2),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
        ),
        title: Row(
          children: [
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Color.fromARGB(254, 17, 32, 44), Color.fromARGB(255, 255, 255, 255), Color.fromARGB(255, 0, 0, 0)],
              ).createShader(bounds),
              child: const Text(
                '✨',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Colors.white, Colors.white70],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ).createShader(bounds),
              child: Center(
                child: const Text(
                  'Cinephile Hub',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const CustomDrawer(),
      body: _screens[_currentIndex],
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 10,
              ),
            ],
          ),
          child: CrystalNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            items: _navItems,
            backgroundColor: Colors.black.withOpacity(0.5),
            borderWidth: 0.5,
            outlineBorderColor: Colors.white24,
          ),
        ),
      ),
    );
  }
}