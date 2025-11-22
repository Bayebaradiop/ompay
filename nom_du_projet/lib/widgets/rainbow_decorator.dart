import 'package:flutter/material.dart';

class RainbowDecorator extends StatelessWidget {
  final Widget child;
  final bool showRainbow;

  const RainbowDecorator({
    Key? key,
    required this.child,
    this.showRainbow = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!showRainbow) return child;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: CustomPaint(
              size: const Size(80, 200),
              painter: RainbowPainter(),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class RainbowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Liste des couleurs arc-en-ciel
    final colors = [
      const Color(0xFF6B5FFF), // Violet
      const Color(0xFF4A9FFF), // Bleu
      const Color(0xFF00D4AA), // Cyan/Vert
      const Color(0xFFFFC107), // Jaune
      const Color(0xFFFF9800), // Orange
    ];

    final double spacing = 12;
    final double startX = size.width;

    for (int i = 0; i < colors.length; i++) {
      paint.color = colors[i];
      
      final path = Path();
      final yStart = i * spacing;
      
      // Courbe qui part du coin supérieur droit vers le bas
      path.moveTo(startX, yStart);
      path.cubicTo(
        startX - 20, yStart + 30,
        startX - 40, yStart + 60,
        startX - 60, yStart + 90,
      );
      
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
