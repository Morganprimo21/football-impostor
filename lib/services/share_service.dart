import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/logger.dart';
import '../utils/app_colors.dart';

/// Servicio para compartir resultados del juego
/// Genera texto formateado para compartir en redes sociales
class ShareService {
  static final ShareService _instance = ShareService._internal();
  factory ShareService() => _instance;
  ShareService._internal();

  /// Genera texto para compartir resultado de partida
  String generateGameResultText({
    required String impostor,
    required String secretPlayer,
    required int totalPlayers,
    required int impostorCount,
    required bool includeHashtags,
  }) {
    final buffer = StringBuffer();
    
    buffer.writeln('🎮 Football Impostor - Resultado');
    buffer.writeln('');
    buffer.writeln('👥 Jugadores: $totalPlayers');
    buffer.writeln('🎭 Impostores: $impostorCount');
    buffer.writeln('');
    buffer.writeln('🕵️ El impostor era: $impostor');
    buffer.writeln('⚽ Jugador: $secretPlayer');
    buffer.writeln('');
    
    if (includeHashtags) {
      buffer.writeln('#FootballImpostor #JuegoDeCartas #PartyGame');
    }

    return buffer.toString();
  }

  /// Copia el resultado al portapapeles
  Future<void> copyToClipboard({
    required BuildContext context,
    required String impostor,
    required String secretPlayer,
    required int totalPlayers,
    required int impostorCount,
  }) async {
    try {
      final text = generateGameResultText(
        impostor: impostor,
        secretPlayer: secretPlayer,
        totalPlayers: totalPlayers,
        impostorCount: impostorCount,
        includeHashtags: true,
      );

      await Clipboard.setData(ClipboardData(text: text));

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('✅ Resultado copiado al portapapeles'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }

      AppLogger.info('Game result copied to clipboard');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to copy to clipboard', e, stackTrace);
    }
  }

  /// Genera estadísticas para compartir
  String generateStatsText({
    required int gamesPlayed,
    required int gamesWon,
    required int impostorWins,
    required double winRate,
  }) {
    final buffer = StringBuffer();
    
    buffer.writeln('📊 Mis Estadísticas - Football Impostor');
    buffer.writeln('');
    buffer.writeln('🎮 Partidas jugadas: $gamesPlayed');
    buffer.writeln('✅ Victorias: $gamesWon');
    buffer.writeln('🎭 Victorias como impostor: $impostorWins');
    buffer.writeln('📈 Tasa de victoria: ${winRate.toStringAsFixed(1)}%');
    buffer.writeln('');
    buffer.writeln('¡Descarga Football Impostor y juega con tus amigos!');
    buffer.writeln('#FootballImpostor #PartyGame');

    return buffer.toString();
  }
}

