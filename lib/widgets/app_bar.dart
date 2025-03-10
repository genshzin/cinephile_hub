import 'package:flutter/material.dart';
import 'dart:ui';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool automaticallyImplyLeading;
  final Widget? leading;
  final bool centerTitle;
  final double height;
  final bool useGradient;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.automaticallyImplyLeading = true,
    this.leading,
    this.centerTitle = true,
    this.height = 60.0,
    this.useGradient = true,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AppBar(
            backgroundColor: Colors.black.withOpacity(0.2),
            elevation: 0,
            automaticallyImplyLeading: automaticallyImplyLeading,
            leading: leading,
            centerTitle: centerTitle,
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (useGradient) ...[
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Color.fromARGB(254, 17, 32, 44), Color.fromARGB(255, 255, 255, 255), Color.fromARGB(255, 0, 0, 0)],
                    ).createShader(bounds),
                    child: const Text(
                      '✨ ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Colors.white, Colors.white70],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ).createShader(bounds),
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
            flexibleSpace: Container(
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
            iconTheme: const IconThemeData(
              color: Colors.white,
              size: 24,
            ),
            actions: actions,
          ),
        ),
      ),
    );
  }
}
