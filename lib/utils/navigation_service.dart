import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';

/// Servicio centralizado para navegación
class NavigationService {
  NavigationService._();

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static BuildContext? get context => navigatorKey.currentContext;

  /// Navega a una nueva pantalla
  static Future<T?> push<T>(
    Widget page, {
    bool replace = false,
    GameProvider? gameProvider,
  }) {
    final ctx = context;
    if (ctx == null) return Future.value(null);

    final route = MaterialPageRoute<T>(builder: (_) {
      if (gameProvider != null) {
        return ChangeNotifierProvider.value(value: gameProvider, child: page);
      }
      return page;
    });

    if (replace) {
      return Navigator.of(ctx).pushReplacement<T, T>(route);
    }
    return Navigator.of(ctx).push<T>(route);
  }

  /// Navega y reemplaza todas las rutas anteriores
  static Future<T?> pushAndRemoveUntil<T>(
    Widget page, {
    GameProvider? gameProvider,
  }) {
    final ctx = context;
    if (ctx == null) return Future.value(null);

    final route = MaterialPageRoute<T>(builder: (_) {
      if (gameProvider != null) {
        return ChangeNotifierProvider.value(value: gameProvider, child: page);
      }
      return page;
    });

    return Navigator.of(ctx).pushAndRemoveUntil<T>(
      route,
      (route) => false,
    );
  }

  /// Regresa a la pantalla anterior
  static void pop<T>([T? result]) {
    final ctx = context;
    if (ctx != null) {
      Navigator.of(ctx).pop(result);
    }
  }

  /// Regresa hasta encontrar la primera ruta
  static void popUntilFirst() {
    final ctx = context;
    if (ctx != null) {
      Navigator.of(ctx).popUntil((route) => route.isFirst);
    }
  }

  /// Muestra diálogo
  static Future<T?> showDialogWidget<T>(Widget dialog) {
    final ctx = context;
    if (ctx == null) return Future.value(null);

    return showDialog<T>(
      context: ctx,
      builder: (_) => dialog,
    );
  }
}

