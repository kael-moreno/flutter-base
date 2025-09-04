import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'home_page.dart';

void main() {
  // Configure system navigation bar - will be overridden by theme
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
    ),
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false, // Let AppBar handle the top
      child: MaterialApp(
        title: 'Clean Architecture Flutter Demo',
        theme: _buildLightTheme(),
        darkTheme: _buildDarkTheme(),
        themeMode: ThemeMode.system, // Follows system theme
        home: const HomePage(),
      ),
    );
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      colorScheme:
          ColorScheme.fromSeed(
            seedColor: const Color(0xFF1877F2), // Facebook blue
            brightness: Brightness.light,
          ).copyWith(
            primary: const Color(0xFF1877F2), // Facebook blue
            secondary: const Color(0xFF42A5F5), // Lighter blue accent
            surface: Colors.white,
            onPrimary: Colors.white,
            onSecondary: Colors.white,
            onSurface: const Color(0xFF1C1E21), // Facebook dark text
          ),
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFFF0F2F5), // Facebook light gray
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1877F2), // Facebook blue
        foregroundColor: Colors.white,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          systemNavigationBarColor: Color(0xFFF0F2F5),
          systemNavigationBarIconBrightness: Brightness.dark,
          statusBarColor: Color(0xFF1877F2),
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1877F2),
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      cardTheme: const CardThemeData(
        color: Colors.white,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      colorScheme:
          ColorScheme.fromSeed(
            seedColor: const Color(0xFF1877F2), // Facebook blue
            brightness: Brightness.dark,
          ).copyWith(
            primary: const Color(
              0xFF4E9FFF,
            ), // Lighter Facebook blue for dark mode
            secondary: const Color(0xFF42A5F5), // Blue accent
            surface: const Color(0xFF242526), // Facebook dark surface
            onPrimary: Colors.white,
            onSecondary: Colors.white,
            onSurface: const Color(0xFFE4E6EA), // Facebook light text on dark
          ),
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(
        0xFF18191A,
      ), // Facebook dark background
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF242526), // Facebook dark surface
        foregroundColor: Color(0xFFE4E6EA), // Facebook light text
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          systemNavigationBarColor: Color(0xFF18191A),
          systemNavigationBarIconBrightness: Brightness.light,
          statusBarColor: Color(0xFF242526),
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(
            0xFF4E9FFF,
          ), // Lighter blue for dark mode
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      cardTheme: const CardThemeData(
        color: Color(0xFF242526), // Facebook dark surface for cards
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    );
  }
}
