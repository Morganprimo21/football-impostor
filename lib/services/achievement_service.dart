import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../utils/logger.dart';

/// Servicio para gestionar logros locales
class AchievementService {
  static final AchievementService _instance = AchievementService._internal();
  factory AchievementService() => _instance;
  AchievementService._internal();

  static const String _prefKeyAchievements = 'unlocked_achievements';
  static const String _prefKeyProgress = 'achievement_progress';

  final List<Achievement> _achievements = [
    Achievement(
      id: 'first_game',
      title: 'Primera Partida',
      description: 'Completa tu primera partida',
      icon: '🎮',
      category: AchievementCategory.games,
    ),
    Achievement(
      id: 'first_win_agent',
      title: 'Agente Novato',
      description: 'Gana tu primera partida como agente',
      icon: '🕵️',
      category: AchievementCategory.victories,
    ),
    Achievement(
      id: 'first_win_impostor',
      title: 'Impostor Maestro',
      description: 'Gana tu primera partida como impostor',
      icon: '🎭',
      category: AchievementCategory.victories,
    ),
    Achievement(
      id: 'marathon_5',
      title: 'Maratón',
      description: 'Juega 5 partidas seguidas',
      icon: '🏃',
      category: AchievementCategory.games,
      requiredProgress: 5,
    ),
    Achievement(
      id: 'marathon_10',
      title: 'Adicto',
      description: 'Juega 10 partidas',
      icon: '🔥',
      category: AchievementCategory.games,
      requiredProgress: 10,
    ),
    Achievement(
      id: 'perfect_impostor',
      title: 'Impostor Perfecto',
      description: 'Gana como impostor sin recibir votos',
      icon: '👻',
      category: AchievementCategory.special,
    ),
    Achievement(
      id: 'detective',
      title: 'Detective',
      description: 'Identifica al impostor 3 veces',
      icon: '🔍',
      category: AchievementCategory.victories,
      requiredProgress: 3,
    ),
    Achievement(
      id: 'party_animal',
      title: 'Fiestero',
      description: 'Juega con 10+ jugadores',
      icon: '🎉',
      category: AchievementCategory.special,
    ),
    Achievement(
      id: 'veteran',
      title: 'Veterano',
      description: 'Completa 50 partidas',
      icon: '⭐',
      category: AchievementCategory.games,
      requiredProgress: 50,
    ),
    Achievement(
      id: 'legend',
      title: 'Leyenda',
      description: 'Completa 100 partidas',
      icon: '👑',
      category: AchievementCategory.games,
      requiredProgress: 100,
    ),
  ];

  Set<String> _unlockedAchievements = {};
  Map<String, int> _achievementProgress = {};

  List<Achievement> get allAchievements => List.unmodifiable(_achievements);
  
  List<Achievement> get unlockedAchievements {
    return _achievements
        .where((a) => _unlockedAchievements.contains(a.id))
        .toList();
  }

  int get unlockedCount => _unlockedAchievements.length;
  int get totalCount => _achievements.length;

  Future<void> loadAchievements() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Cargar logros desbloqueados
      final unlockedJson = prefs.getString(_prefKeyAchievements);
      if (unlockedJson != null) {
        _unlockedAchievements = Set<String>.from(json.decode(unlockedJson));
      }
      
      // Cargar progreso
      final progressJson = prefs.getString(_prefKeyProgress);
      if (progressJson != null) {
        final decoded = json.decode(progressJson) as Map<String, dynamic>;
        _achievementProgress = decoded.map(
          (key, value) => MapEntry(key, value as int),
        );
      }
      
      AppLogger.info('Achievements loaded: ${_unlockedAchievements.length}/$totalCount');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to load achievements', e, stackTrace);
    }
  }

  Future<Achievement?> unlockAchievement(String achievementId) async {
    if (_unlockedAchievements.contains(achievementId)) {
      return null; // Ya desbloqueado
    }

    final achievement = _achievements.firstWhere((a) => a.id == achievementId);
    _unlockedAchievements.add(achievementId);
    
    await _saveAchievements();
    
    AppLogger.info('Achievement unlocked: ${achievement.title}');
    return achievement;
  }

  Future<Achievement?> updateProgress(String achievementId, int progress) async {
    final achievement = _achievements.firstWhere((a) => a.id == achievementId);
    
    if (achievement.requiredProgress == null) {
      return null; // No tiene progreso
    }

    if (_unlockedAchievements.contains(achievementId)) {
      return null; // Ya desbloqueado
    }

    _achievementProgress[achievementId] = progress;

    if (progress >= achievement.requiredProgress!) {
      return await unlockAchievement(achievementId);
    }

    await _saveProgress();
    return null;
  }

  int getProgress(String achievementId) {
    return _achievementProgress[achievementId] ?? 0;
  }

  bool isUnlocked(String achievementId) {
    return _unlockedAchievements.contains(achievementId);
  }

  Future<void> _saveAchievements() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _prefKeyAchievements,
        json.encode(_unlockedAchievements.toList()),
      );
    } catch (e, stackTrace) {
      AppLogger.error('Failed to save achievements', e, stackTrace);
    }
  }

  Future<void> _saveProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _prefKeyProgress,
        json.encode(_achievementProgress),
      );
    } catch (e, stackTrace) {
      AppLogger.error('Failed to save achievement progress', e, stackTrace);
    }
  }

  Future<void> resetAchievements() async {
    _unlockedAchievements.clear();
    _achievementProgress.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefKeyAchievements);
    await prefs.remove(_prefKeyProgress);
    AppLogger.info('Achievements reset');
  }
}

class Achievement {
  final String id;
  final String title;
  final String description;
  final String icon;
  final AchievementCategory category;
  final int? requiredProgress;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.category,
    this.requiredProgress,
  });
}

enum AchievementCategory {
  games,
  victories,
  special,
}

