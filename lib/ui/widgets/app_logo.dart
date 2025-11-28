import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Widget reutilizable para mostrar el logo de la app de forma consistente
class AppLogo extends StatelessWidget {
  final double size;
  final bool showCircleBackground;
  final Color? backgroundColor;
  final bool useWhiteLogo;

  const AppLogo({
    Key? key,
    this.size = 120,
    this.showCircleBackground = false,
    this.backgroundColor,
    this.useWhiteLogo = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Usar el logo SVG limpio sin fondo
    final Widget logoImage = SvgPicture.asset(
      'assets/hector_logo.svg',
      width: size,
      height: size,
      fit: BoxFit.contain,
      placeholderBuilder: (_) => Icon(
        Icons.sports_soccer,
        size: size * 0.6,
        color: useWhiteLogo ? Colors.white : const Color(0xFF2D4A3E),
      ),
    );

    // Siempre mostrar el logo sin fondo circular
    return SizedBox(
      width: size,
      height: size,
      child: logoImage,
    );
  }
}

