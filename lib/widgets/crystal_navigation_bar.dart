import 'package:flutter/material.dart';

enum SelectedTab { home, search, myJournal, bookmark, aboutMe }

class IconlyLight {
  static const IconData home = Icons.home_outlined;
  static const IconData search = Icons.search;
  static const IconData add = Icons.add;
  static const IconData bookmark = Icons.bookmark_outline;
  static const IconData user = Icons.person_outline;
}

class IconlyBold {
  static const IconData home = Icons.home;
  static const IconData search = Icons.search;
  static const IconData plus = Icons.add;
  static const IconData bookmark = Icons.bookmark;
  static const IconData user_2 = Icons.person;
}

class CrystalNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final Color unselectedItemColor;
  final Color backgroundColor;
  final List<CrystalNavigationBarItem> items;
  final double borderWidth;
  final Color outlineBorderColor;

  const CrystalNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    this.unselectedItemColor = Colors.grey,
    this.backgroundColor = Colors.transparent,
    required this.items,
    this.borderWidth = 1.0,
    this.outlineBorderColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: outlineBorderColor,
          width: borderWidth,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          items.length,
          (index) => GestureDetector(
            onTap: () => onTap(index),
            behavior: HitTestBehavior.opaque,
            child: SizedBox(
              height: 56,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  items[index]._buildIcon(index == currentIndex),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CrystalNavigationBarItem {
  final IconData icon;
  final IconData unselectedIcon;
  final Color selectedColor;
  final Widget? badge;

  CrystalNavigationBarItem({
    required this.icon,
    required this.unselectedIcon,
    required this.selectedColor,
    this.badge,
  });

  Widget _buildIcon(bool isSelected) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(
          isSelected ? icon : unselectedIcon,
          color: isSelected ? selectedColor : Colors.white70,
          size: 24,
        ),
        if (badge != null)
          Positioned(
            top: -5,
            right: -5,
            child: badge!,
          ),
      ],
    );
  }
}

class Badge extends StatelessWidget {
  final Widget label;

  const Badge({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(10),
      ),
      constraints: const BoxConstraints(
        minWidth: 16,
        minHeight: 16,
      ),
      child: Center(child: label),
    );
  }
}
