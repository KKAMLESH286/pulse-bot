import 'package:flutter/material.dart';

import 'package:track_me/core/theme/app_theme.dart';

class GradientIcon extends StatelessWidget {
  const GradientIcon({
    super.key,
    required this.icon,
    this.size = 24,
    this.gradient = AppTheme.primaryGradient,
  });

  final IconData icon;
  final double size;
  final LinearGradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => gradient.createShader(bounds),
      child: Icon(icon, size: size, color: Colors.white),
    );
  }
}
