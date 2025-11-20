import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'providers/premium_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final premiumProvider = PremiumProvider();
  await premiumProvider.loadPremiumStatus();
  runApp(
    ChangeNotifierProvider.value(
      value: premiumProvider,
      child: const MyAppWrapper(),
    ),
  );
}
