import 'package:flutter/material.dart';

class GlazeBadge extends StatelessWidget {
  const GlazeBadge({super.key, required this.badge, this.size = 17});

  final String? badge;
  final double size;

  Color? get _color {
    switch (badge) {
      case 'blue':
        return const Color(0xFF1DA1F2);
      case 'orange':
        return const Color(0xFFFF6B00);
      case 'green':
        return const Color(0xFF22C55E);
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _color;
    if (color == null) return const SizedBox.shrink();

    return Tooltip(
      message: 'Official Glazer',
      triggerMode: TooltipTriggerMode.tap,
      child: Container(
        width: size,
        height: size,
        margin: const EdgeInsets.only(left: 3, right: 7),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.35),
              blurRadius: 8,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Icon(
          Icons.verified,
          color: color,
          size: size,
        ),
      ),
    );
  }
}
