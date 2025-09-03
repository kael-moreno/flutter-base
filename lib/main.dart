import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'home_page.dart';

void main() {
  // Configure system navigation bar to match Facebook theme
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Color(0xFFF0F2F5), // Facebook light gray
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarColor: Color(0xFF1877F2), // Facebook blue
      statusBarIconBrightness: Brightness.light,
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
        theme: ThemeData(
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
          // Configure system UI overlay for consistent navigation bar
          appBarTheme: AppBarTheme(
            backgroundColor: const Color(0xFF1877F2), // Facebook blue
            foregroundColor: Colors.white,
            elevation: 0,
            systemOverlayStyle: const SystemUiOverlayStyle(
              systemNavigationBarColor: Colors.transparent,
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          cardTheme: const CardThemeData(
            color: Colors.white,
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
        ),
        home: const HomePage(),
      ),
    );
  }
}
