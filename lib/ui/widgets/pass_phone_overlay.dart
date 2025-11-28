import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/app_colors.dart';

/// Overlay que muestra "PASA EL MÓVIL A [NOMBRE]" con countdown
class PassPhoneOverlay extends StatefulWidget {
  final String nextPlayerName;
  final VoidCallback onComplete;
  final int countdownSeconds;

  const PassPhoneOverlay({
    Key? key,
    required this.nextPlayerName,
    required this.onComplete,
    this.countdownSeconds = 3,
  }) : super(key: key);

  /// Muestra el overlay como diálogo modal
  static Future<void> show({
    required BuildContext context,
    required String nextPlayerName,
    int countdownSeconds = 3,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black,
      builder: (context) => PassPhoneOverlay(
        nextPlayerName: nextPlayerName,
        countdownSeconds: countdownSeconds,
        onComplete: () => Navigator.of(context).pop(),
      ),
    );
  }

  @override
  State<PassPhoneOverlay> createState() => _PassPhoneOverlayState();
}

class _PassPhoneOverlayState extends State<PassPhoneOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  int _currentCount = 0;
  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    _currentCount = widget.countdownSeconds;

    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _startCountdown();
  }

  Future<void> _startCountdown() async {
    // Esperar 1.5 segundos antes de empezar countdown
    await Future.delayed(const Duration(milliseconds: 1500));

    for (int i = _currentCount; i > 0; i--) {
      if (!mounted) return;

      setState(() {
        _currentCount = i;
        _isReady = false;
      });

      // Vibración
      HapticFeedback.mediumImpact();

      // Animación
      _controller.forward(from: 0);

      await Future.delayed(const Duration(seconds: 1));
    }

    if (!mounted) return;

    // Estado "LISTO"
    setState(() {
      _isReady = true;
      _currentCount = 0;
    });

    // Vibración fuerte
    HapticFeedback.heavyImpact();

    // Esperar un momento y cerrar
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      widget.onComplete();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icono de pasar móvil
            Icon(
              Icons.phonelink_ring,
              size: 100,
              color: _isReady ? AppColors.success : AppColors.primary,
            ),
            const SizedBox(height: 40),

            // Texto "PASA EL MÓVIL A"
            Text(
              'PASA EL MÓVIL A',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.white70,
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 16),

            // Nombre del jugador
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withOpacity(0.3),
                    AppColors.secondary.withOpacity(0.3),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _isReady ? AppColors.success : AppColors.primary,
                  width: 3,
                ),
                boxShadow: _isReady
                    ? [
                        BoxShadow(
                          color: AppColors.success,
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ]
                    : [],
              ),
              child: Text(
                widget.nextPlayerName.toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 2,
                  shadows: [
                    Shadow(
                      color: _isReady ? AppColors.success : AppColors.primary,
                      blurRadius: 20,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 60),

            // Countdown o "LISTO"
            if (!_isReady && _currentCount > 0)
              ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary.withOpacity(0.2),
                    border: Border.all(
                      color: AppColors.primary,
                      width: 4,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '$_currentCount',
                      style: TextStyle(
                        fontSize: 72,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              )
            else if (_isReady)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                decoration: BoxDecoration(
                  color: AppColors.success,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.success,
                      blurRadius: 30,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.check_circle, color: Colors.white, size: 40),
                    SizedBox(width: 16),
                    Text(
                      '¡LISTO!',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              )
            else
              const SizedBox(height: 120),

            const SizedBox(height: 40),

            // Instrucción
            if (!_isReady)
              Text(
                'Preparando...',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white54,
                  fontStyle: FontStyle.italic,
                ),
              )
            else
              Text(
                '¡Toca la pantalla!',
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.success,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

