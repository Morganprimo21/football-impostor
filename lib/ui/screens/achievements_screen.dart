import 'package:flutter/material.dart';
import '../../services/achievement_service.dart';
import '../../utils/app_colors.dart';

/// Pantalla que muestra todos los logros
class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({Key? key}) : super(key: key);

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  final AchievementService _achievementService = AchievementService();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAchievements();
  }

  Future<void> _loadAchievements() async {
    setState(() => _isLoading = true);
    await _achievementService.loadAchievements();
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDeep,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '${_achievementService.unlockedCount}/${_achievementService.totalCount}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: EdgeInsets.fromLTRB(
                16.0,
                16.0,
                16.0,
                16.0 + MediaQuery.of(context).padding.bottom,
              ),
              itemCount: _achievementService.allAchievements.length,
              itemBuilder: (context, index) {
                final achievement = _achievementService.allAchievements[index];
                final isUnlocked = _achievementService.isUnlocked(achievement.id);
                final progress = _achievementService.getProgress(achievement.id);

                return _buildAchievementCard(achievement, isUnlocked, progress);
              },
            ),
    );
  }

  Widget _buildAchievementCard(
    Achievement achievement,
    bool isUnlocked,
    int progress,
  ) {
    final Color color = _getCategoryColor(achievement.category);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isUnlocked
            ? color.withOpacity(0.2)
            : AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUnlocked ? color : AppColors.border,
          width: isUnlocked ? 2 : 1,
        ),
        boxShadow: isUnlocked
            ? [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          // Icono/Emoji
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: isUnlocked
                  ? color.withOpacity(0.3)
                  : Colors.grey.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                achievement.icon,
                style: TextStyle(
                  fontSize: 32,
                  color: isUnlocked ? Colors.white : Colors.grey,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  achievement.title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isUnlocked ? Colors.white : Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  achievement.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: isUnlocked ? Colors.white70 : Colors.grey.shade600,
                  ),
                ),
                
                // Barra de progreso si aplica
                if (achievement.requiredProgress != null && !isUnlocked) ...[
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress / achievement.requiredProgress!,
                      backgroundColor: Colors.grey.shade800,
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                      minHeight: 8,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$progress / ${achievement.requiredProgress}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          // Check si está desbloqueado
          if (isUnlocked)
            Icon(
              Icons.check_circle,
              color: color,
              size: 32,
            )
          else
            Icon(
              Icons.lock,
              color: Colors.grey.shade700,
              size: 28,
            ),
        ],
      ),
    );
  }

  Color _getCategoryColor(AchievementCategory category) {
    switch (category) {
      case AchievementCategory.games:
        return AppColors.primary;
      case AchievementCategory.victories:
        return AppColors.success;
      case AchievementCategory.special:
        return AppColors.accent;
    }
  }
}

