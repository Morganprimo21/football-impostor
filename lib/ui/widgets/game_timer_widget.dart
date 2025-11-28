import 'package:flutter/material.dart';
import '../../services/timer_service.dart';
import '../../utils/app_colors.dart';
import '../../services/sound_service.dart';

/// Widget de timer visual para el juego
class GameTimerWidget extends StatefulWidget {
  final int initialSeconds;
  final bool autoStart;
  final VoidCallback? onFinished;

  const GameTimerWidget({
    Key? key,
    required this.initialSeconds,
    this.autoStart = false,
    this.onFinished,
  }) : super(key: key);

  @override
  State<GameTimerWidget> createState() => _GameTimerWidgetState();
}

class _GameTimerWidgetState extends State<GameTimerWidget> {
  late TimerService _timerService;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    _timerService = TimerService(
      onTick: () => setState(() {}),
      onFinished: () {
        SoundService().playButtonError(); // Sonido de alarma
        widget.onFinished?.call();
        setState(() {});
      },
    );

    if (widget.autoStart && widget.initialSeconds > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _timerService.start(widget.initialSeconds);
      });
    }
  }

  @override
  void dispose() {
    _timerService.dispose();
    super.dispose();
  }

  void _toggleTimer() {
    if (_timerService.isRunning) {
      _timerService.pause();
      _isPaused = true;
    } else if (_timerService.remainingSeconds > 0) {
      _timerService.resume();
      _isPaused = false;
    } else {
      _timerService.start(widget.initialSeconds);
      _isPaused = false;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final progress = _timerService.progress;
    final isLowTime = _timerService.remainingSeconds <= 30;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isLowTime ? AppColors.error : AppColors.border,
          width: 2,
        ),
        boxShadow: isLowTime
            ? [
                BoxShadow(
                  color: AppColors.errorGlow,
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Timer circular
          SizedBox(
            width: 120,
            height: 120,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Círculo de progreso
                CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 8,
                  backgroundColor: AppColors.border,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isLowTime ? AppColors.error : AppColors.primary,
                  ),
                ),
                // Tiempo restante
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _timerService.formattedTime,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isLowTime ? AppColors.error : AppColors.primary,
                      ),
                    ),
                    if (_isPaused)
                      Text(
                        'PAUSA',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.textTertiary,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Botones de control
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(
                  _timerService.isRunning ? Icons.pause : Icons.play_arrow,
                  color: AppColors.primary,
                ),
                onPressed: _toggleTimer,
                tooltip: _timerService.isRunning ? 'Pausar' : 'Iniciar',
              ),
              IconButton(
                icon: const Icon(Icons.stop, color: AppColors.error),
                onPressed: () {
                  _timerService.stop();
                  setState(() {});
                },
                tooltip: 'Detener',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

