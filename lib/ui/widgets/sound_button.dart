import 'package:flutter/material.dart';
import '../../services/sound_service.dart';

/// Botón que reproduce sonido al ser presionado
class SoundButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final SoundType soundType;
  final ButtonStyle? style;

  const SoundButton({
    Key? key,
    required this.child,
    this.onPressed,
    this.soundType = SoundType.click,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final soundService = SoundService();

    return ElevatedButton(
      style: style,
      onPressed: onPressed == null
          ? null
          : () {
              // Reproducir sonido antes de ejecutar la acción
              switch (soundType) {
                case SoundType.click:
                  soundService.playButtonClick();
                  break;
                case SoundType.success:
                  soundService.playButtonSuccess();
                  break;
                case SoundType.error:
                  soundService.playButtonError();
                  break;
                case SoundType.vote:
                  soundService.playVote();
                  break;
                case SoundType.reveal:
                  soundService.playRoleReveal();
                  break;
              }

              // Ejecutar la acción después de un pequeño delay para que el sonido se escuche
              Future.delayed(const Duration(milliseconds: 50), () {
                onPressed?.call();
              });
            },
      child: child,
    );
  }
}

/// Tipos de sonidos disponibles
enum SoundType {
  click,
  success,
  error,
  vote,
  reveal,
}

/// Wrapper para OutlinedButton con sonido
class SoundOutlinedButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final SoundType soundType;
  final ButtonStyle? style;

  const SoundOutlinedButton({
    Key? key,
    required this.child,
    this.onPressed,
    this.soundType = SoundType.click,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final soundService = SoundService();

    return OutlinedButton(
      style: style,
      onPressed: onPressed == null
          ? null
          : () {
              switch (soundType) {
                case SoundType.click:
                  soundService.playButtonClick();
                  break;
                case SoundType.success:
                  soundService.playButtonSuccess();
                  break;
                case SoundType.error:
                  soundService.playButtonError();
                  break;
                case SoundType.vote:
                  soundService.playVote();
                  break;
                case SoundType.reveal:
                  soundService.playRoleReveal();
                  break;
              }

              Future.delayed(const Duration(milliseconds: 50), () {
                onPressed?.call();
              });
            },
      child: child,
    );
  }
}

/// Wrapper para TextButton con sonido
class SoundTextButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final SoundType soundType;
  final ButtonStyle? style;

  const SoundTextButton({
    Key? key,
    required this.child,
    this.onPressed,
    this.soundType = SoundType.click,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final soundService = SoundService();

    return TextButton(
      style: style,
      onPressed: onPressed == null
          ? null
          : () {
              switch (soundType) {
                case SoundType.click:
                  soundService.playButtonClick();
                  break;
                case SoundType.success:
                  soundService.playButtonSuccess();
                  break;
                case SoundType.error:
                  soundService.playButtonError();
                  break;
                case SoundType.vote:
                  soundService.playVote();
                  break;
                case SoundType.reveal:
                  soundService.playRoleReveal();
                  break;
              }

              Future.delayed(const Duration(milliseconds: 50), () {
                onPressed?.call();
              });
            },
      child: child,
    );
  }
}

