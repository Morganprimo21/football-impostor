import 'package:flutter/widgets.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const _localizedValues = <String, Map<String, String>>{
    'title': {
      'es': 'Football Impostor',
      'en': 'Football Impostor',
    },
    'start_subtitle': {
      'es': 'Pass & Play — Todo hablado. Doble toque para avanzar.',
      'en': 'Pass & Play — Spoken only. Double tap to advance.',
    },
    'start_play': {
      'es': 'Comenzar',
      'en': 'Play',
    },
    'start_remove_ads': {
      'es': 'Premium',
      'en': 'Premium',
    },
    'start_how_to_play': {
      'es': 'Cómo jugar',
      'en': 'How to play',
    },
    'dialog_how_to_play_title': {
      'es': 'Cómo jugar',
      'en': 'How to play',
    },
    'dialog_how_to_play_body': {
      'es':
          'Modo Pass & Play. Introduce los nombres en la siguiente pantalla. Durante la partida, todo se hace hablado y las pantallas secretas avanzan solo con doble toque.',
      'en':
          'Pass & Play mode. Enter the names on the next screen. During the game, everything is spoken and secret screens only advance with a double tap.',
    },
    'dialog_close': {
      'es': 'Cerrar',
      'en': 'Close',
    },
    'tutorial_do_not_show_again': {
      'es': 'No volver a mostrar',
      'en': 'Don\'t show again',
    },
    'home_num_players': {
      'es': 'Nº JUGADORES',
      'en': 'PLAYERS',
    },
    'home_headline': {
      'es': 'CONFIGURAR PARTIDA',
      'en': 'SETUP GAME',
    },
    'home_player_label': {
      'es': 'Jugador',
      'en': 'Player',
    },
    'home_player_hint': {
      'es': 'Nombre Jugador',
      'en': 'Player Name',
    },
    'home_error_min_players': {
      'es': 'Se requieren al menos 3 jugadores',
      'en': 'At least 3 players required',
    },
    'home_error_unique_names': {
      'es': 'Los nombres deben ser únicos',
      'en': 'Names must be unique',
    },
    'tournament_error_start': {
      'es': 'Error al iniciar torneo',
      'en': 'Error starting tournament',
    },
    'setup_league_selected': {
      'es': 'Liga seleccionada',
      'en': 'Selected league',
    },
    'setup_change': {
      'es': 'Cambiar',
      'en': 'Change',
    },
    'setup_players': {
      'es': 'Jugadores:',
      'en': 'Players:',
    },
    'setup_impostors': {
      'es': 'Impostores:',
      'en': 'Impostors:',
    },
    'setup_player_names': {
      'es': 'Nombres de jugadores',
      'en': 'Player names',
    },
    'setup_default_player': {
      'es': 'Jugador',
      'en': 'Player',
    },
    'home_quick_game_button': {
      'es': 'PARTIDA RÁPIDA',
      'en': 'QUICK GAME',
    },
    'home_tournament_button': {
      'es': 'TORNEO',
      'en': 'TOURNAMENT',
    },
    'home_how_to_play_button': {
      'es': 'CÓMO JUGAR',
      'en': 'HOW TO PLAY',
    },
    'quick_game_title': {
      'es': 'PARTIDA RÁPIDA',
      'en': 'QUICK GAME',
    },
    'quick_game_subtitle': {
      'es': 'Configura y empieza a jugar',
      'en': 'Configure and start playing',
    },
    'tournament_mode_title': {
      'es': 'MODO TORNEO',
      'en': 'TOURNAMENT',
    },
    'tournament_agents_won': {
      'es': 'AGENTES GANARON',
      'en': 'AGENTS WON',
    },
    'tournament_impostor_won': {
      'es': 'IMPOSTOR GANÓ',
      'en': 'IMPOSTOR WON',
    },
    'tournament_mode_subtitle': {
      'es': 'Compite en una serie de partidas',
      'en': 'Compete in a series of matches',
    },
    'how_to_play_title': {
      'es': 'CÓMO JUGAR',
      'en': 'HOW TO PLAY',
    },
    'premium_price': {
      'es': '2,99 € al mes',
      'en': '€2.99 per month',
    },
    'premium_what_includes': {
      'es': '¿QUÉ INCLUYE?',
      'en': 'WHAT\'S INCLUDED?',
    },
    'premium_all_leagues': {
      'es': 'Todas las Ligas',
      'en': 'All Leagues',
    },
    'premium_all_leagues_desc': {
      'es': 'Premier League, LaLiga, Serie A, Bundesliga y Legends',
      'en': 'Premier League, LaLiga, Serie A, Bundesliga and Legends',
    },
    'premium_no_ads': {
      'es': 'Sin Anuncios',
      'en': 'No Ads',
    },
    'premium_no_ads_desc': {
      'es': 'Elimina todos los banners y pantallas publicitarias',
      'en': 'Remove all banners and advertising screens',
    },
    'premium_ideal_parties': {
      'es': 'Ideal para Fiestas',
      'en': 'Perfect for Parties',
    },
    'premium_ideal_parties_desc': {
      'es': 'Juega torneos largos sin interrupciones',
      'en': 'Play long tournaments without interruptions',
    },
    'premium_cancel_anytime': {
      'es': 'Cancela Cuando Quieras',
      'en': 'Cancel Anytime',
    },
    'premium_cancel_anytime_desc': {
      'es': 'Sin compromiso, cancela tu suscripción en cualquier momento',
      'en': 'No commitment, cancel your subscription anytime',
    },
    'premium_activate': {
      'es': 'Activar Premium 2,99 €/mes',
      'en': 'Activate Premium €2.99/month',
    },
    'premium_restore': {
      'es': 'Restaurar compras',
      'en': 'Restore purchases',
    },
    'premium_pending': {
      'es': 'Compra pendiente...',
      'en': 'Purchase pending...',
    },
    'premium_failed': {
      'es': 'La compra ha fallado',
      'en': 'Purchase failed',
    },
    'premium_only_stores': {
      'es': 'Las compras solo están disponibles en Android/iOS desde la tienda.',
      'en': 'Purchases are only available on Android/iOS from the store.',
    },
    'home_start_cta': {
      'es': 'INICIAR PARTIDA',
      'en': 'START GAME',
    },
    'home_cta': {
      'es': 'INICIAR PARTIDA',
      'en': 'START GAME',
    },
    'home_default_agent': {
      'es': 'Agente',
      'en': 'Agent',
    },
    'home_remove_ads': {
      'es': 'Premium',
      'en': 'Premium',
    },
    'home_remove_ads_coming_soon': {
      'es': 'Premium (próximamente)',
      'en': 'Premium (coming soon)',
    },
    'home_difficulty': {
      'es': 'Dificultad',
      'en': 'Difficulty',
    },
    'home_difficulty_easy': {
      'es': 'Fácil (1 impostor)',
      'en': 'Easy (1 impostor)',
    },
    'home_difficulty_medium': {
      'es': 'Medio (1 impostor, 2 informados)',
      'en': 'Medium (1 impostor, 2 informed)',
    },
    'home_difficulty_hard': {
      'es': 'Difícil (2 impostores)',
      'en': 'Hard (2 impostors)',
    },
    'home_league': {
      'es': 'Liga',
      'en': 'League',
    },
    'home_league_mixed': {
      'es': 'Mezcla total',
      'en': 'Mixed',
    },
    'home_league_premier': {
      'es': 'Premier League',
      'en': 'Premier League',
    },
    'home_league_laliga': {
      'es': 'LaLiga',
      'en': 'LaLiga',
    },
    'home_league_seriea': {
      'es': 'Serie A',
      'en': 'Serie A',
    },
    'home_league_bundes': {
      'es': 'Bundesliga',
      'en': 'Bundesliga',
    },
    'home_league_ligue1': {
      'es': 'Ligue 1',
      'en': 'Ligue 1',
    },
    'settings_title': {
      'es': 'Configuración',
      'en': 'Settings',
    },
    'settings_language': {
      'es': 'Idioma',
      'en': 'Language',
    },
    'settings_language_es': {
      'es': 'Español',
      'en': 'Spanish',
    },
    'settings_language_en': {
      'es': 'Inglés',
      'en': 'English',
    },
    'settings_how_to_play': {
      'es': 'Cómo jugar',
      'en': 'How to play',
    },
    'settings_how_to_play_sub': {
      'es': 'Aprender las reglas',
      'en': 'Learn the rules',
    },
    'settings_sounds': {
      'es': 'Sonidos',
      'en': 'Sounds',
    },
    'settings_sounds_sub': {
      'es': 'Activar o desactivar efectos de sonido',
      'en': 'Enable or disable sound effects',
    },
    'settings_premium': {
      'es': 'Premium – Ligas + sin anuncios',
      'en': 'Premium – Leagues + no ads',
    },
    'settings_premium_sub': {
      'es':
          'Acceso a todas las ligas (incluidas leyendas) y sin anuncios por 2,99 € al mes.',
      'en':
          'Access to all leagues (including legends) and no ads for €2.99 per month.',
    },
    'settings_premium_btn': {
      'es': 'Activar Premium 2,99 €/mes',
      'en': 'Activate Premium €2.99 / month',
    },
    'settings_rate': {
      'es': 'Calificar App',
      'en': 'Rate App',
    },
    'settings_rate_sub': {
      'es': '¿Te encanta el juego? Deja una reseña',
      'en': 'Love the game? Leave a review',
    },
    'settings_feedback': {
      'es': 'Enviar Comentarios',
      'en': 'Send Feedback',
    },
    'settings_feedback_sub': {
      'es': 'Comparte ideas para mejoras',
      'en': 'Share ideas for improvements',
    },
    'settings_other_apps': {
      'es': 'Otras aplicaciones',
      'en': 'Other apps',
    },
    'settings_app_info': {
      'es': 'Información de la App',
      'en': 'App Info',
    },
    'lobby_title': {
      'es': 'SALA DE REUNIÓN',
      'en': 'BRIEFING ROOM',
    },
    'lobby_are_you': {
      'es': '¿Eres',
      'en': 'Are you',
    },
    'lobby_impostor': {
      'es': 'ERES EL IMPOSTOR',
      'en': 'YOU ARE THE IMPOSTOR',
    },
    'lobby_innocent_agent': {
      'es': 'AGENTE INOCENTE',
      'en': 'INNOCENT AGENT',
    },
    'lobby_no_know_player': {
      'es': 'No conoces al jugador.\nEscucha a los demás y finge saber de quién hablan.',
      'en': 'You don\'t know the player.\nListen to others and pretend you know who they\'re talking about.',
    },
    'lobby_the_player_is': {
      'es': 'El jugador es:',
      'en': 'The player is:',
    },
    'lobby_confirm_identity': {
      'es': 'Confirma tu identidad para ver tu información secreta.',
      'en': 'Confirm your identity to see your secret information.',
    },
    'lobby_see_role': {
      'es': 'VER ROL',
      'en': 'SEE ROLE',
    },
    'lobby_understood': {
      'es': 'ENTENDIDO',
      'en': 'UNDERSTOOD',
    },
    'lobby_confirmed': {
      'es': 'CONFIRMADO',
      'en': 'CONFIRMED',
    },
    'lobby_instruction': {
      'es': 'Toca tu tarjeta para recibir tu identidad y el jugador.',
      'en': 'Tap your card to see your role and the player.',
    },
    'lobby_waiting': {
      'es': 'ESPERANDO CONFIRMACIÓN...',
      'en': 'WAITING FOR CONFIRMATION...',
    },
    'lobby_start': {
      'es': 'INICIAR PARTIDA',
      'en': 'START GAME',
    },
    'tournament_start': {
      'es': 'INICIAR TORNEO',
      'en': 'START TOURNAMENT',
    },
    'tournament_rounds': {
      'es': 'Número de rondas:',
      'en': 'Number of rounds:',
    },
    'tournament_best_of': {
      'es': 'Best of',
      'en': 'Best of',
    },
    'clue_title': {
      'es': 'FASE DE DISCUSIÓN',
      'en': 'CLUE PHASE',
    },
    'clue_headline': {
      'es': '¡DEBATE ABIERTO!',
      'en': 'OPEN DEBATE!',
    },
    'clue_body': {
      'es':
          '1. Hablad por turnos y dad pistas sutiles sobre vuestro jugador.\n\n2. El impostor debe mentir para encajar.\n\n3. Los inocentes deben descubrir quién no sabe de qué habla.',
      'en':
          '1. Speak in turns and give subtle clues about your player.\n\n2. The impostor must lie to blend in.\n\n3. The innocents must find who has no idea who the player is.',
    },
    'clue_next_hint': {
      'es': 'Cuando hayáis terminado de debatir:',
      'en': 'When you are done debating:',
    },
    'clue_next_cta': {
      'es': 'PROCEDER A VOTACIÓN',
      'en': 'GO TO VOTING',
    },
    'vote_title': {
      'es': 'HORA DE VOTAR',
      'en': 'TIME TO VOTE',
    },
    'vote_headline': {
      'es': 'SEÑALEN AL SOSPECHOSO',
      'en': 'POINT AT THE SUSPECT',
    },
    'vote_body': {
      'es':
          'A la cuenta de 3, señalad con el dedo a quién creéis que es el impostor.',
      'en':
          'On the count of 3, point with your finger at who you think the impostor is.',
    },
    'vote_cta': {
      'es': 'VER RESULTADOS',
      'en': 'SEE RESULTS',
    },
    'reveal_title': {
      'es': 'Revelar',
      'en': 'Reveal',
    },
    'reveal_impostor_label': {
      'es': 'IMPOSTOR',
      'en': 'IMPOSTOR',
    },
    'reveal_secret_player': {
      'es': 'Jugador',
      'en': 'Player',
    },
    'reveal_new_game': {
      'es': 'Nueva partida',
      'en': 'New game',
    },
    'reveal_select_winner': {
      'es': 'SELECCIONAR GANADOR',
      'en': 'SELECT WINNER',
    },
    'reveal_share_result': {
      'es': 'COMPARTIR RESULTADO',
      'en': 'SHARE RESULT',
    },
    'reveal_view_tournament': {
      'es': 'VER TORNEO',
      'en': 'VIEW TOURNAMENT',
    },
    'reveal_select_winner_first': {
      'es': 'PRIMERO SELECCIONA GANADOR ↑',
      'en': 'FIRST SELECT WINNER ↑',
    },
    'reveal_view_podium': {
      'es': 'VER PODIO FINAL',
      'en': 'VIEW FINAL PODIUM',
    },
    'reveal_hint': {
      'es': 'Pulsa \"Nueva partida\" para reiniciar',
      'en': 'Tap "New game" to restart',
    },
    'reveal_agents_win': {
      'es': '¡Los agentes han atrapado al impostor!',
      'en': 'Agents caught the impostor!',
    },
    'reveal_impostor_win': {
      'es': 'El impostor ha escapado sin ser descubierto.',
      'en': 'The impostor escaped undetected.',
    },
    'reveal_agents_win_button': {
      'es': 'Adivinamos bien',
      'en': 'We guessed right',
    },
    'reveal_impostor_win_button': {
      'es': 'Se equivocaron',
      'en': 'They were wrong',
    },
    'reveal_continue': {
      'es': 'Continuar',
      'en': 'Continue',
    },
    'voting_phase_title': {
      'es': 'Fase de Votación',
      'en': 'Voting Phase',
    },
    'voting_phase_subtitle': {
      'es': '¡Es hora de discutir y votar por el impostor!',
      'en': 'It\'s time to discuss and vote for the impostor!',
    },
    'voting_phase_how_to_vote': {
      'es': 'Cómo Votar',
      'en': 'How to Vote',
    },
    'voting_phase_initial_player': {
      'es': 'Jugador Inicial',
      'en': 'Initial Player',
    },
    'voting_phase_starts_round': {
      'es': 'comienza la ronda',
      'en': 'starts the round',
    },
    'voting_phase_group_discussion': {
      'es': 'Discusión Grupal',
      'en': 'Group Discussion',
    },
    'voting_phase_group_discussion_desc': {
      'es': 'Vayan en sentido horario',
      'en': 'Go clockwise',
    },
    'voting_phase_time_to_vote': {
      'es': 'Hora de Votar',
      'en': 'Time to Vote',
    },
    'voting_phase_time_to_vote_desc': {
      'es': 'Cada jugador dice una palabra relacionada con el secreto. Den dos o tres vueltas.',
      'en': 'Each player says a word related to the secret. Do two or three rounds.',
    },
    'voting_phase_revelation': {
      'es': 'Fase de Revelación',
      'en': 'Revelation Phase',
    },
    'voting_phase_revelation_desc': {
      'es': 'Voten por el jugador que creen que es el impostor, luego toquen para revelar los resultados.',
      'en': 'Vote for the player you think is the impostor, then tap to reveal the results.',
    },
    'voting_phase_reveal_results': {
      'es': 'Revelar resultados',
      'en': 'Reveal results',
    },
  };

  String text(String key) {
    final lang = locale.languageCode;
    final values = _localizedValues[key];
    if (values == null) return key;
    return values[lang] ?? values['es'] ?? key;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      locale.languageCode == 'es' || locale.languageCode == 'en';

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) =>
      false;
}
