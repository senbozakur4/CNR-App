import 'package:flutter/material.dart';
import '../main.dart'; // импортируем глобальные Notifier

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Список языков
    final Map<String, String> languages = {
      'English': 'en',
      'Русский': 'ru',
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки'),
        backgroundColor: Colors.black,
      ),
      body: ListView(
        children: [
          // Переключатель темы
          ValueListenableBuilder<ThemeMode>(
            valueListenable: themeNotifier,
            builder: (context, currentTheme, child) {
              return ListTile(
                title: const Text('Тема приложения'),
                trailing: Switch(
                  value: currentTheme == ThemeMode.dark,
                  onChanged: (value) {
                    themeNotifier.value =
                        value ? ThemeMode.dark : ThemeMode.light;
                  },
                ),
              );
            },
          ),
          const Divider(color: Colors.grey),

          // Список языков
          ListTile(
            title: const Text('Язык интерфейса'),
            subtitle: ValueListenableBuilder<String>(
              valueListenable: languageNotifier,
              builder: (context, currentLang, child) {
                return DropdownButton<String>(
                  value: currentLang,
                  items: languages.entries
                      .map((e) => DropdownMenuItem(
                            value: e.value,
                            child: Text(e.key),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      languageNotifier.value = value;
                    }
                  },
                );
              },
            ),
          ),
          const Divider(color: Colors.grey),

          // О приложении
          ListTile(
            title: const Text('О приложении'),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('О приложении'),
                  content: const Text(
                      'CNR-App — мобильное приложение для управления техникой.\nВерсия: 1.0\nРазработчик: [Фамилия Имя]'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Закрыть'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
