import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';

/// Servicio para verificar y monitorear la conectividad a internet
class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  bool _isConnected = false;
  Timer? _periodicCheck;
  final List<Function(bool)> _listeners = [];

  bool get isConnected => _isConnected;

  /// Inicia el monitoreo periódico de conectividad
  void startMonitoring() {
    // Verificar inmediatamente
    checkConnectivity();
    
    // Verificar cada 5 segundos
    _periodicCheck = Timer.periodic(const Duration(seconds: 5), (_) {
      checkConnectivity();
    });
  }

  /// Detiene el monitoreo
  void stopMonitoring() {
    _periodicCheck?.cancel();
    _periodicCheck = null;
  }

  /// Verifica la conectividad haciendo una petición real
  Future<bool> checkConnectivity() async {
    try {
      // Intentar conectar a Google DNS (rápido y confiable)
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 5));
      
      final wasConnected = _isConnected;
      _isConnected = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      
      // Notificar a los listeners si cambió el estado
      if (wasConnected != _isConnected) {
        _notifyListeners(_isConnected);
      }
      
      return _isConnected;
    } on SocketException catch (_) {
      final wasConnected = _isConnected;
      _isConnected = false;
      
      if (wasConnected != _isConnected) {
        _notifyListeners(_isConnected);
      }
      
      return false;
    } on TimeoutException catch (_) {
      final wasConnected = _isConnected;
      _isConnected = false;
      
      if (wasConnected != _isConnected) {
        _notifyListeners(_isConnected);
      }
      
      return false;
    } catch (e) {
      debugPrint('Error verificando conectividad: $e');
      final wasConnected = _isConnected;
      _isConnected = false;
      
      if (wasConnected != _isConnected) {
        _notifyListeners(_isConnected);
      }
      
      return false;
    }
  }

  /// Añade un listener para cambios de conectividad
  void addListener(Function(bool) listener) {
    _listeners.add(listener);
  }

  /// Remueve un listener
  void removeListener(Function(bool) listener) {
    _listeners.remove(listener);
  }

  /// Notifica a todos los listeners
  void _notifyListeners(bool isConnected) {
    for (var listener in _listeners) {
      try {
        listener(isConnected);
      } catch (e) {
        debugPrint('Error notificando listener: $e');
      }
    }
  }

  /// Limpia recursos
  void dispose() {
    stopMonitoring();
    _listeners.clear();
  }
}

