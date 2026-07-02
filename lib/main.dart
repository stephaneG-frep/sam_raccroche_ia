import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/numbers_provider.dart';
import 'providers/protection_provider.dart';
import 'providers/responder_provider.dart';
import 'providers/settings_provider.dart';
import 'screens/home_screen.dart';
import 'services/call_service.dart';
import 'services/notification_service.dart';
import 'services/storage_service.dart';
import 'services/tts_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = StorageService();
  await storage.init();
  final notifications = NotificationService();
  await notifications.init();
  final tts = TtsService();
  await tts.init();

  runApp(
    MultiProvider(
      providers: [
        Provider<StorageService>.value(value: storage),
        ChangeNotifierProvider(
          create: (_) => SettingsProvider(storage)..load(),
        ),
        ChangeNotifierProvider(create: (_) => NumbersProvider(storage)..load()),
        ChangeNotifierProvider(
          create: (_) => ResponderProvider(storage, tts)..load(),
        ),
        ChangeNotifierProvider(
          create: (_) =>
              ProtectionProvider(storage, CallService(), notifications)..load(),
        ),
      ],
      child: const SamRaccrocheApp(),
    ),
  );
}

class SamRaccrocheApp extends StatelessWidget {
  const SamRaccrocheApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    return MaterialApp(
      title: 'Sam Raccroche IA',
      debugShowCheckedModeBanner: false,
      themeMode: settings.themeMode,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFC62828)),
        useMaterial3: true,
        cardTheme: const CardThemeData(
          margin: EdgeInsets.symmetric(vertical: 6),
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF5252),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        cardTheme: const CardThemeData(
          margin: EdgeInsets.symmetric(vertical: 6),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
