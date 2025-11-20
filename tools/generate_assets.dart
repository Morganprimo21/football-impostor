import 'dart:convert';
import 'dart:io';

/// Run this script locally (dart run tools/generate_assets.dart)
/// It will create valid 1x1 transparent PNG files for the hector placeholders.
void main() {
  const base64Png =
      'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR4nGNgYAAAAAMAASsJTYQAAAAASUVORK5CYII=';
  final bytes = base64Decode(base64Png);
  final assets = [
    'assets/hector_logo.png',
    'assets/hector_background.png',
    'assets/hector_icon.png',
    'assets/hector_banner.png',
  ];
  for (final path in assets) {
    final file = File(path);
    file.createSync(recursive: true);
    file.writeAsBytesSync(bytes);
    stdout.writeln('Wrote $path');
  }
  stdout.writeln('Assets generated. Now run: flutter pub get && flutter run');
}
