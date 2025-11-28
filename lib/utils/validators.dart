import 'constants.dart';

/// Utilidades de validación
class Validators {
  Validators._();

  /// Valida el nombre de un jugador
  static String? validatePlayerName(String? name, String locale) {
    if (name == null || name.trim().isEmpty) {
      return locale == 'es' ? 'El nombre no puede estar vacío' : 'Name cannot be empty';
    }

    final trimmed = name.trim();
    if (trimmed.length < AppConstants.minNameLength) {
      return ErrorMessages.invalidName(locale);
    }

    if (trimmed.length > AppConstants.maxNameLength) {
      return ErrorMessages.invalidName(locale);
    }

    return null;
  }

  /// Valida el número de jugadores
  static bool isValidPlayerCount(int count) {
    return count >= AppConstants.minPlayers && count <= AppConstants.maxPlayers;
  }

  /// Normaliza el nombre de un jugador (trim y capitalize)
  static String normalizePlayerName(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return trimmed;
    return trimmed[0].toUpperCase() + trimmed.substring(1).toLowerCase();
  }

  /// Valida que todos los nombres sean únicos
  static bool areNamesUnique(List<String> names) {
    final normalized = names.map((n) => normalizePlayerName(n).toLowerCase()).toList();
    return normalized.toSet().length == normalized.length;
  }
}

