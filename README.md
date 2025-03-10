# Cinephile Hub

## About the Application
Cinephile Hub adalah aplikasi browsing film berbasis Flutter yang dirancang untuk memberikan pengalaman eksplorasi film. Aplikasi ini memanfaatkan API dari The Movie Database (TMDb) untuk mengambil data film lengkap dan menampilkannya melalui antarmuka.

## Features
- **Movie Discovery**: Browse now playing, popular, top-rated, and trending movies
- **Search Functionality**: Find movies by title with real-time results
- **Detailed Information**: View comprehensive details about each movie
- **Personal Journal**: Track watched movies, liked movies, add reviews and ratings
- **Bookmarking System**: Create custom movie lists and collections
- **Abour Me** : Read developer's personal informations

## Technologies and Packages
- **Provider Package**: Implemented for efficient state management across the application
- **HTTP**: For API integration with TMDb
- **SharedPreferences**: Local storage for user data and preferences
- **Carousel Slider**: Creating engaging movie showcases
- **Shimmer**: Elegant loading state animations
- **URL Launcher**: Opening external links 
- **crystal_navigation_bar**: Bottom navigation bar

## Learning Outcomes
Selama pengembangan aplikasi ini, ada beberapa pembelajaran penting yang saya dapatkan. Pertama, saya memilih Provider sebagai state management utama karena kesederhanaan dan efektivitasnya. Dibanding package lain yang lebih kompleks, Provider menawarkan pendekatan lightweight yang cocok untuk kebutuhan aplikasi. Dengan membuat multiple providers (MovieProvider, JournalProvider, BookmarkProvider), saya bisa memisahkan logic secara modular sekaligus menjaga codebase tetap rapi. Tantangan terbesar adalah mengelola state antar-screen, yang akhirnya teratasi dengan metode provider spesifik untuk tiap use case. Kedua, Pengalaman pertama integrasi dengan TMDB API membuka wawasan tentang desain data model, API service class, dan error handling. Menggunakan package http, saya membangun arsitektur layanan terpisah antara network request dan UI logic, sehingga aplikasi lebih mudah di-maintain dan di-test. Ketiga, implementasi hero transitions untuk detail film, shimmer effects untuk loading states, dan custom transitions antar layar mengharuskan saya untuk mendalami sistem animasi Flutter. asilnya, UI terasa lebih responsif dan engaging menurut saya. Keempat, Shared Preferences terbukti sangat berguna untuk penyimpanan data pengguna seperti entri jurnal dan bookmark. Proses serialization/deserialization objek kompleks ke format JSON sempat menantang, tetapi hasilnya cukup memuaskan karena saya jadi tidak harus mengulang mengisi data ketika testing fungsionalitas. Tantangan umum selama pengembangan adalah kompleksitas state management dan integrasi API TMDB karena baru pertama kali menggunakan API mereka (Postman sangat membantu dalam proses ini), kemudian gimana cara implementasi provider yang benar dan efisien. Proyek ini telah secara substansial meningkatkan keterampilan pengembangan Flutter saya dan mengajarkan saya untuk membuat aplikasi yang fungsional dan menarik secara visual. Untuk ke depannya, saya merencanakan untuk lebih mengevaluasi desain, mengeksplor komunitas pub dev, serta autentikasi dan otorisasi (misalnya dengan menggunakan third party seperti google)

## References
- Flutter Documentation (flutter.dev)
- The Movie Database API Documentation (developers.themoviedb.org)
- Package Documentation (pub.dev)
- Youtube tutorials: 
https://youtu.be/FlFyrOEz2S4?si=vNdeRzChS2I8iUV-
https://www.youtube.com/watch?v=ZeO4qzgouks



