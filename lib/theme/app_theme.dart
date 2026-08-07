// theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const background = Color(0xFFFFF8F0);
  static const primary = Color(0xFFFF6B4A);
  static const secondary = Color(0xFF2D9596);
  static const accent = Color(0xFFFFC93C);
  static const textDark = Color(0xFF1F2937);
  static const textMuted = Color(0xFF8C8B92);
  static const cardWhite = Color(0xFFFFFFFF);
}

TextStyle heading(
  double size, {
  Color color = AppColors.textDark,
  FontWeight weight = FontWeight.w600,
}) {
  return GoogleFonts.fredoka(
    fontSize: size,
    color: color,
    fontWeight: weight,
    height: 1.1,
  );
}

TextStyle body(
  double size, {
  Color color = AppColors.textDark,
  FontWeight weight = FontWeight.w400,
}) {
  return GoogleFonts.inter(
    fontSize: size,
    color: color,
    fontWeight: weight,
  );
}

class BlobBackground extends StatelessWidget {
  final Color color;
  final double width;
  final double height;

  const BlobBackground({
    super.key,
    required this.color,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _BlobClipper(),
      child: Container(width: width, height: height, color: color),
    );
  }
}

class _BlobClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;
    final path = Path();
    path.moveTo(w * 0.15, 0);
    path.quadraticBezierTo(w * 0.95, -h * 0.02, w, h * 0.30);
    path.quadraticBezierTo(w * 1.02, h * 0.65, w * 0.78, h * 0.92);
    path.quadraticBezierTo(w * 0.45, h * 1.08, w * 0.12, h * 0.85);
    path.quadraticBezierTo(-w * 0.05, h * 0.55, w * 0.02, h * 0.25);
    path.quadraticBezierTo(w * 0.05, h * 0.05, w * 0.15, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
