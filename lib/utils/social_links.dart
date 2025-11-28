import 'package:url_launcher/url_launcher.dart';

/// URLs y datos de contacto oficiales de Football Impostor
class SocialLinks {
  static final Uri instagram =
      Uri.parse('https://www.instagram.com/football_impostor/');

  static final Uri tikTok =
      Uri.parse('https://www.tiktok.com/@football_impostor');

  static final Uri emailSupport = Uri(
    scheme: 'mailto',
    path: 'footballimpostor@gmail.com',
    queryParameters: <String, String>{
      'subject': 'Feedback Football Impostor',
    },
  );

  /// Abre un [uri] en una aplicación externa (navegador, cliente de email, etc.)
  /// Devuelve `true` si se ha podido abrir correctamente.
  static Future<bool> openExternal(Uri uri) async {
    return launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}


