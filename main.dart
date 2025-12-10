/// FILE: lib/main.dart
import 'package:flutter/material.dart';
import 'screens/main_screen.dart';
import 'screens/remotes_screen.dart';
import 'services/saved_remotes_service.dart';

// Глобальные ValueNotifier для темы, языка и сохранённых пультов
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.dark);
final ValueNotifier<String> languageNotifier = ValueNotifier('en');
final ValueNotifier<List<Map<String, String>>> savedRemotesNotifier =
    ValueNotifier<List<Map<String, String>>>([]);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SavedRemotesService.init();
  savedRemotesNotifier.value = await SavedRemotesService.loadSavedRemotes();
  runApp(const CnrApp());
}

class CnrApp extends StatelessWidget {
  const CnrApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentTheme, child) {
        return ValueListenableBuilder<String>(
          valueListenable: languageNotifier,
          builder: (context, currentLang, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'CNR-App',
              theme: ThemeData(
                brightness: Brightness.light,
                scaffoldBackgroundColor: Colors.white,
                primaryColor: Colors.purpleAccent,
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.purpleAccent),
                textTheme: const TextTheme(
                  bodyMedium: TextStyle(color: Colors.black),
                  bodySmall: TextStyle(color: Colors.black87),
                ),
              ),
              darkTheme: ThemeData(
                brightness: Brightness.dark,
                scaffoldBackgroundColor: Colors.black,
                primaryColor: Colors.purpleAccent,
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.purpleAccent,
                    brightness: Brightness.dark),
                textTheme: const TextTheme(
                  bodyMedium: TextStyle(color: Colors.white),
                  bodySmall: TextStyle(color: Colors.white70),
                ),
              ),
              themeMode: currentTheme,
              home: const MainScreen(),
            );
          },
        );
      },
    );
  }
}
