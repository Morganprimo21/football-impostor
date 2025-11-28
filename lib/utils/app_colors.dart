import 'package:flutter/material.dart';

/// Paleta de colores moderna con aura para Football Impostor
/// Inspirada en estética cyberpunk/moderna con toques neón elegantes
class AppColors {
  AppColors._();

  // Colores base - Verde oscuro consistente con el diseño
  static const Color backgroundDeep = Color(0xFF1B2E28); // Verde oscuro profundo
  static const Color backgroundSurface = Color(0xFF243830); // Verde oscuro superficie
  static const Color backgroundCard = Color(0xFF2D4A3E); // Verde oscuro para tarjetas
  static const Color backgroundElevated = Color(0xFF3A5549); // Verde medio oscuro

  // Colores primarios - Verde esmeralda brillante
  static const Color primary = Color(0xFF00A86B); // Verde esmeralda
  static const Color primaryDark = Color(0xFF008055); // Verde oscuro
  static const Color primaryLight = Color(0xFF00C97D); // Verde claro
  static const Color primaryGlow = Color(0x6600A86B); // Verde con transparencia para glow

  // Colores secundarios - Púrpura moderado
  static const Color secondary = Color(0xFF8B2BB8); // Púrpura moderado
  static const Color secondaryDark = Color(0xFF6B1F8F); // Púrpura oscuro
  static const Color secondaryLight = Color(0xFFA855D4); // Púrpura claro
  static const Color secondaryGlow = Color(0x668B2BB8); // Púrpura con transparencia para glow

  // Colores de acento - Rosa suave para elementos importantes
  static const Color accent = Color(0xFFCC0058); // Rosa moderado
  static const Color accentDark = Color(0xFF990044); // Rosa oscuro
  static const Color accentLight = Color(0xFFDD2277); // Rosa claro
  static const Color accentGlow = Color(0x66CC0058); // Rosa con transparencia

  // Colores de estado
  static const Color success = Color(0xFF00FF88); // Verde esmeralda neón
  static const Color successDark = Color(0xFF00CC6E); // Verde oscuro
  static const Color successGlow = Color(0x6600FF88); // Verde con glow

  static const Color error = Color(0xFFFF1744); // Rojo neón vibrante
  static const Color errorDark = Color(0xFFCC1236); // Rojo oscuro
  static const Color errorGlow = Color(0x66FF1744); // Rojo con glow

  static const Color warning = Color(0xFFFFB300); // Amarillo neón
  static const Color warningDark = Color(0xFFCC8F00); // Amarillo oscuro

  static const Color info = Color(0xFF00A86B); // Verde (igual que primary)
  static const Color infoDark = Color(0xFF008055);

  // Colores de texto
  static const Color textPrimary = Color(0xFFFFFFFF); // Blanco puro
  static const Color textSecondary = Color(0xFFB0B0B0); // Gris claro
  static const Color textTertiary = Color(0xFF707070); // Gris medio
  static const Color textDisabled = Color(0xFF404040); // Gris oscuro

  // Colores de borde y divisores
  static const Color border = Color(0xFF00A86B); // Verde esmeralda para bordes
  static const Color borderLight = Color(0xFF00C97D); // Verde claro para bordes
  static const Color divider = Color(0xFF2D4A3E); // Divisor verde oscuro

  // Gradientes con aura
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryLight],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [backgroundDeep, backgroundSurface],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [backgroundCard, backgroundElevated],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentDark, secondaryDark],
  );

  // Sombras con glow neón
  static List<BoxShadow> get primaryGlowShadow => [
        BoxShadow(
          color: primaryGlow,
          blurRadius: 20,
          spreadRadius: 2,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: primaryGlow.withOpacity(0.5),
          blurRadius: 40,
          spreadRadius: 4,
          offset: const Offset(0, 8),
        ),
      ];

  static List<BoxShadow> get secondaryGlowShadow => [
        BoxShadow(
          color: secondaryGlow,
          blurRadius: 20,
          spreadRadius: 2,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: secondaryGlow.withOpacity(0.5),
          blurRadius: 40,
          spreadRadius: 4,
          offset: const Offset(0, 8),
        ),
      ];

  static List<BoxShadow> get accentGlowShadow => [
        BoxShadow(
          color: accentGlow,
          blurRadius: 20,
          spreadRadius: 2,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: accentGlow.withOpacity(0.5),
          blurRadius: 40,
          spreadRadius: 4,
          offset: const Offset(0, 8),
        ),
      ];

  static List<BoxShadow> get successGlowShadow => [
        BoxShadow(
          color: successGlow,
          blurRadius: 20,
          spreadRadius: 2,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get errorGlowShadow => [
        BoxShadow(
          color: errorGlow,
          blurRadius: 20,
          spreadRadius: 2,
          offset: const Offset(0, 4),
        ),
      ];
}

