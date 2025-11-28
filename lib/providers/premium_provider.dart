import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/player_pack.dart';

/// Gestiona el estado Premium y los packs comprados.
///
/// - `isPremium`  => Suscripción mensual (todas las ligas desbloqueadas + sin anuncios)
/// - `ownedPacks` => Packs individuales comprados (Premier, LaLiga, Serie A, Bundesliga, Legends)
class PremiumProvider with ChangeNotifier {
  static const _keyPremium = 'is_premium_subscription';
  static const _keyOwnedPacks = 'owned_packs';

  /// Suscripción Premium activa (2,99 €/mes)
  bool isPremium = false;

  /// Ids de packs comprados individualmente (ej: 'seriea', 'bundes', 'legends')
  final Set<String> _ownedPacks = <String>{};

  Set<String> get ownedPacks => _ownedPacks;

  Future<void> loadPremiumStatus() async {
    final prefs = await SharedPreferences.getInstance();
    isPremium = prefs.getBool(_keyPremium) ?? false;
    final stored = prefs.getStringList(_keyOwnedPacks) ?? <String>[];
    _ownedPacks
      ..clear()
      ..addAll(stored);
    notifyListeners();
  }

  /// Activa o desactiva la suscripción Premium (todas las ligas + sin anuncios).
  Future<void> setPremium({required bool value}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyPremium, value);
    isPremium = value;
    notifyListeners();
  }

  /// Marca un pack individual como comprado (compra única).
  Future<void> addOwnedPack(String packId) async {
    if (_ownedPacks.contains(packId)) return;

    final prefs = await SharedPreferences.getInstance();
    _ownedPacks.add(packId);
    await prefs.setStringList(_keyOwnedPacks, _ownedPacks.toList());
    notifyListeners();
  }

  /// Devuelve `true` si el usuario puede usar este pack (Premium o pack comprado).
  bool hasAccessToPack(String packId) {
    final pack = PlayerPack.getById(packId);
    // Packs gratuitos siempre disponibles
    if (pack != null && !pack.isPremium) return true;

    // Premium desbloquea todo
    if (isPremium) return true;

    // Si no es gratuito ni Premium global, miramos compra individual
    return _ownedPacks.contains(packId);
  }
}
