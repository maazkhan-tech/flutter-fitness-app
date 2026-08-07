// screens/widgets/glass_card.dart
import 'package:flutter/material.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final List<BoxShadow>? boxShadow;
  final Gradient? gradient;

  const GlassCard({
    super.key,
    required this.child,
    this.blur = 20,
    this.opacity = 0.08,
    this.borderRadius = 20,
    this.padding = const EdgeInsets.all(16),
    this.boxShadow,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: getDecoration(
        blur: blur,
        opacity: opacity,
        borderRadius: borderRadius,
        boxShadow: boxShadow,
        gradient: gradient,
      ),
      child: child,
    );
  }

  static BoxDecoration getDecoration({
    double blur = 20,
    double opacity = 0.08,
    double borderRadius = 20,
    List<BoxShadow>? boxShadow,
    Gradient? gradient,
  }) {
    return BoxDecoration(
      color: Colors.white.withValues(alpha: opacity),
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: Colors.white.withValues(alpha: 0.1),
        width: 1,
      ),
      boxShadow: boxShadow ??
          [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: blur,
              offset: const Offset(0, 4),
            ),
          ],
      gradient: gradient,
    );
  }
}
