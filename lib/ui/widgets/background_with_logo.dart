import 'package:flutter/material.dart';

/// Widget que muestra el fondo con logo en marca de agua
/// Se usa en todas las pantallas excepto el home
class BackgroundWithLogo extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;

  const BackgroundWithLogo({
    Key? key,
    required this.child,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage('assets/hector_background.jpg'),
          fit: BoxFit.cover,
          alignment: Alignment.center,
          opacity: 1.0,
          onError: (exception, stackTrace) {
            // Si falla, usar color sólido de respaldo
          },
        ),
        color: backgroundColor ?? const Color(0xFF1B2E28),
      ),
      child: child,
    );
  }
}

