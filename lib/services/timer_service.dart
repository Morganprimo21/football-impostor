import 'dart:async';
import 'package:flutter/material.dart';
import '../utils/logger.dart';

/// Servicio para gestionar timers en el juego
class TimerService {
  Timer? _timer;
  int _remainingSeconds = 0;
  final VoidCallback? _onTick;
  final VoidCallback? _onFinished;

  TimerService({
    VoidCallback? onTick,
    VoidCallback? onFinished,
  })  : _onTick = onTick,
        _onFinished = onFinished;

  int get remainingSeconds => _remainingSeconds;
  bool get isRunning => _timer?.isActive ?? false;
  bool get isFinished => _remainingSeconds <= 0 && !isRunning;

  String get formattedTime {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  double get progress {
    if (_totalSeconds == 0) return 0.0;
    return 1.0 - (_remainingSeconds / _totalSeconds);
  }

  int _totalSeconds = 0;

  /// Inicia el timer con duración en segundos
  void start(int durationSeconds) {
    _totalSeconds = durationSeconds;
    _remainingSeconds = durationSeconds;
    _timer?.cancel();
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        _onTick?.call();
        
        if (_remainingSeconds == 0) {
          _timer?.cancel();
          _onFinished?.call();
          AppLogger.info('Timer finished');
        }
      }
    });
    
    AppLogger.info('Timer started: $durationSeconds seconds');
  }

  /// Pausa el timer
  void pause() {
    _timer?.cancel();
    AppLogger.info('Timer paused at $_remainingSeconds seconds');
  }

  /// Reanuda el timer
  void resume() {
    if (_remainingSeconds > 0 && !isRunning) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
          _onTick?.call();
          
          if (_remainingSeconds == 0) {
            _timer?.cancel();
            _onFinished?.call();
            AppLogger.info('Timer finished');
          }
        }
      });
      AppLogger.info('Timer resumed');
    }
  }

  /// Detiene y resetea el timer
  void stop() {
    _timer?.cancel();
    _remainingSeconds = 0;
    _totalSeconds = 0;
    AppLogger.info('Timer stopped');
  }

  /// Añade tiempo extra
  void addTime(int seconds) {
    _remainingSeconds += seconds;
    _totalSeconds += seconds;
    AppLogger.info('Added $seconds seconds to timer');
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;
  }
}

