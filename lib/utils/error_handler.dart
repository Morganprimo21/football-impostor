import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'logger.dart';
import 'app_localizations.dart';

/// Manejador centralizado de errores
class ErrorHandler {
  ErrorHandler._();

  /// Maneja errores y muestra mensaje apropiado al usuario
  static void handleError(
    BuildContext context,
    dynamic error, {
    String? contextInfo,
    VoidCallback? onRetry,
    bool showSnackbar = true,
  }) {
    // Log del error
    AppLogger.error(
      contextInfo ?? 'Error occurred',
      error,
      StackTrace.current,
    );

    if (!showSnackbar) return;

    final loc = AppLocalizations.of(context);
    String message = _getUserFriendlyMessage(error, loc);

    // Mostrar snackbar con opción de retry si está disponible
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        duration: const Duration(seconds: 4),
        action: onRetry != null
            ? SnackBarAction(
                label: loc.locale.languageCode == 'es' ? 'Reintentar' : 'Retry',
                textColor: Colors.white,
                onPressed: onRetry,
              )
            : null,
      ),
    );

    // Haptic feedback para errores
    HapticFeedback.heavyImpact();
  }

  /// Obtiene mensaje amigable para el usuario
  static String _getUserFriendlyMessage(dynamic error, AppLocalizations loc) {
    final errorString = error.toString().toLowerCase();
    final isSpanish = loc.locale.languageCode == 'es';

    if (errorString.contains('network') || errorString.contains('internet')) {
      return isSpanish
          ? 'Error de conexión. Verifica tu internet.'
          : 'Connection error. Check your internet.';
    }

    if (errorString.contains('timeout')) {
      return isSpanish
          ? 'Tiempo de espera agotado. Intenta de nuevo.'
          : 'Timeout. Please try again.';
    }

    if (errorString.contains('purchase') || errorString.contains('compra')) {
      return isSpanish
          ? 'Error en la compra. Intenta más tarde.'
          : 'Purchase error. Try again later.';
    }

    if (errorString.contains('ad') || errorString.contains('anuncio')) {
      return isSpanish
          ? 'Error al cargar anuncio. Continúa jugando.'
          : 'Ad loading error. Continue playing.';
    }

    if (errorString.contains('sound') || errorString.contains('sonido')) {
      return ''; // Silenciar errores de sonido
    }

    // Mensaje genérico
    return isSpanish
        ? 'Algo salió mal. Por favor, intenta de nuevo.'
        : 'Something went wrong. Please try again.';
  }

  /// Maneja errores silenciosamente (solo log)
  static void handleSilentError(dynamic error, {String? contextInfo}) {
    AppLogger.warning('${contextInfo ?? 'Silent error'}: $error');
  }

  /// Muestra mensaje de éxito
  static void showSuccess(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 2),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: duration,
      ),
    );
    HapticFeedback.lightImpact();
  }

  /// Muestra mensaje informativo
  static void showInfo(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blue,
        duration: duration,
      ),
    );
  }
}

