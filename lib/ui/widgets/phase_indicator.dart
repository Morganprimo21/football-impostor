import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

/// Widget que muestra el indicador de fase actual del juego
class PhaseIndicator extends StatelessWidget {
  final GamePhase currentPhase;
  
  const PhaseIndicator({
    Key? key,
    required this.currentPhase,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final phases = [
      _PhaseData(
        phase: GamePhase.discussion,
        label: 'DISCUSIÓN',
        icon: Icons.chat_bubble_outline,
        color: AppColors.primary,
      ),
      _PhaseData(
        phase: GamePhase.voting,
        label: 'VOTACIÓN',
        icon: Icons.how_to_vote,
        color: AppColors.accent,
      ),
      _PhaseData(
        phase: GamePhase.results,
        label: 'RESULTADOS',
        icon: Icons.emoji_events,
        color: AppColors.success,
      ),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: phases.map((phaseData) {
          final isActive = phaseData.phase == currentPhase;
          final isPast = _isPhasePast(phaseData.phase, currentPhase);
          
          return Expanded(
            child: _buildPhaseItem(phaseData, isActive, isPast),
          );
        }).toList(),
      ),
    );
  }

  bool _isPhasePast(GamePhase phase, GamePhase current) {
    final order = [GamePhase.discussion, GamePhase.voting, GamePhase.results];
    return order.indexOf(phase) < order.indexOf(current);
  }

  Widget _buildPhaseItem(_PhaseData data, bool isActive, bool isPast) {
    final color = isActive 
        ? data.color 
        : (isPast ? data.color.withOpacity(0.5) : AppColors.textTertiary);
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          data.icon,
          color: color,
          size: isActive ? 28 : 24,
        ),
        const SizedBox(height: 4),
        Text(
          data.label,
          style: TextStyle(
            color: color,
            fontSize: isActive ? 12 : 10,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        if (isActive) ...[
          const SizedBox(height: 4),
          Container(
            width: 40,
            height: 3,
            decoration: BoxDecoration(
              color: data.color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ],
    );
  }
}

class _PhaseData {
  final GamePhase phase;
  final String label;
  final IconData icon;
  final Color color;

  _PhaseData({
    required this.phase,
    required this.label,
    required this.icon,
    required this.color,
  });
}

enum GamePhase {
  discussion,
  voting,
  results,
}

