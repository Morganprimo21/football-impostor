import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Widget para mostrar el logo en formato vectorial (SVG) con fallback a JPG
class VectorLogo extends StatelessWidget {
  final double width;
  final double height;
  final BoxFit fit;

  const VectorLogo({
    Key? key,
    this.width = 250,
    this.height = 250,
    this.fit = BoxFit.contain,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: SvgPicture.asset(
        'assets/hector_logo.svg',
        width: width,
        height: height,
        fit: fit,
        placeholderBuilder: (context) => Icon(
          Icons.sports_soccer,
          size: width * 0.8,
          color: Colors.white,
        ),
      ),
    );
  }
}

/// Widget para mostrar el logo pequeño en un círculo (para listas, cards, etc)
class CircularVectorLogo extends StatelessWidget {
  final double size;

  const CircularVectorLogo({
    Key? key,
    this.size = 40,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: SvgPicture.asset(
        'assets/hector_logo.svg',
        fit: BoxFit.contain,
        placeholderBuilder: (context) => Icon(
          Icons.sports_soccer,
          size: size * 0.6,
          color: Colors.white,
        ),
      ),
    );
  }
}

