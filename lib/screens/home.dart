import 'package:flutter/material.dart';
import 'package:cinephile_hub/widgets/drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'CineHub',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      drawer: const CustomDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _buildSection('Featured Movies', 200.0),
          ),
          SliverToBoxAdapter(
            child: _buildSection('Trending Now', 180.0),
          ),
          SliverToBoxAdapter(
            child: _buildSection('Popular Movies', 180.0),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, double height) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: height,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 10,
            itemBuilder: (context, index) {
              return Container(
                width: 130,
                margin: const EdgeInsets.only(left: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[850],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Icon(
                    Icons.movie_outlined,
                    color: Colors.grey[400],
                    size: 40,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}