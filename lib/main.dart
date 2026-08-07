// main.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fitness_ui_showcase/theme/app_theme.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const FitFlowApp());
}

class FitFlowApp extends StatelessWidget {
  const FitFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FitFlow Pro',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: GoogleFonts.inter().fontFamily,
        useMaterial3: true,
        splashColor: AppColors.primary.withValues(alpha: 0.2),
        highlightColor: AppColors.primary.withValues(alpha: 0.1),
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.cardWhite,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
