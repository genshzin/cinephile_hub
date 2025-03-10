import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'providers/movie_provider.dart';
import 'providers/journal_provider.dart';
import 'providers/bookmark_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final journalProvider = JournalProvider();
  final bookmarkProvider = BookmarkProvider();
  
  await journalProvider.loadEntries();
  await bookmarkProvider.loadLists();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MovieProvider()),
        ChangeNotifierProvider.value(value: journalProvider),
        ChangeNotifierProvider.value(value: bookmarkProvider),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CineHub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.black87,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          elevation: 0,
        ),
      ),
      home: const HomePage(),
    );
  }
}

