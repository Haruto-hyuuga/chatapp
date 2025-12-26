import 'package:chatapp/core/theme.dart';
import 'package:flutter/material.dart';

class DarkGlassBackground extends StatelessWidget {
  const DarkGlassBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0B0B0F), // almost black
            Color(0xFF121217), // very dark gray/blue
            Color(0xFF1C1C24), // subtle bluish tint
          ],
          stops: [0.0, 0.6, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // Optional: soft radial highlights behind glassy inputs
          Positioned(
            left: -120,
            top: -100,
            child: Container(
              width: 450,
              height: 450,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    DefaultColors.authPageElements.withValues(alpha: 0.15),
                    Colors.transparent,
                  ],
                  radius: 0.8,
                ),
              ),
            ),
          ),
          Positioned(
            right: -150,
            bottom: -150,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    DefaultColors.authPageElements.withValues(alpha: 0.15),
                    Colors.transparent,
                  ],
                  radius: 0.7,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
