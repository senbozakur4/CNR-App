import 'package:flutter/material.dart';
import '../main.dart';
import 'remotes_screen.dart';
import 'remote_control_screen.dart';
import 'multi_control_screen.dart';
import 'automation_screen.dart';
import '../texts.dart';
import 'form_screen.dart';
import '../services/saved_remotes_service.dart';
import 'settings_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: languageNotifier,
      builder: (context, lang, child) {
        final t = texts[lang]!; // using texts from your texts.dart
        final textColor = Theme.of(context).textTheme.bodyMedium?.color ?? Colors.white;
        final subTextColor = Theme.of(context).textTheme.bodySmall?.color ?? Colors.white70;

        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        t['app_name']!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                          color: textColor,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.star, color: textColor, size: 28),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const RemotesScreen()),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.settings, color: textColor, size: 28),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const SettingsScreen()),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.person, color: textColor, size: 28),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const FormScreen()),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Voice control big button
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // toggle voice assistant or open multi control voice entry
                            // here we navigate to MultiControlScreen which has advanced control
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const MultiControlScreen()),
                            );
                          },
                          icon: const Icon(Icons.mic, size: 26),
                          label: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            child: Text('Голосовое управление', style: TextStyle(fontSize: 16)),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purpleAccent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Multi-control quick access
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const MultiControlScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purpleAccent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            padding: const EdgeInsets.all(14)),
                        child: const Icon(Icons.devices),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  Text(
                    t['saved_remotes']!,
                    style: TextStyle(fontSize: 16, color: subTextColor),
                  ),
                  const SizedBox(height: 12),

                  // Saved remotes horizontal list
                  ValueListenableBuilder<List<Map<String, String>>>(
                    valueListenable: savedRemotesNotifier,
                    builder: (context, saved, _) {
                      if (saved.isEmpty) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const RemotesScreen()),
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? const Color(0xFF1E1E1E)
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.circular(25),
                            ),
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              children: [
                                Icon(Icons.tv, size: 45, color: Colors.purpleAccent),
                                const SizedBox(width: 16),
                                Text(
                                  'Телевизор',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: textColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return SizedBox(
                        height: 110,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final r = saved[index];
                            return Card(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              color: const Color(0xFF1E1E1E),
                              child: Container(
                                width: 200,
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('${r['device']}', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                                        const SizedBox(height: 6),
                                        Text('${r['brand']}', style: const TextStyle(color: Colors.white70)),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => RemoteControlScreen(deviceName: r['device']!, brand: r['brand']!),
                                              ),
                                            );
                                          },
                                          icon: const Icon(Icons.open_in_new, color: Colors.purpleAccent),
                                        ),
                                        IconButton(
                                          onPressed: () async {
                                            await SavedRemotesService.removeRemote(r);
                                            savedRemotesNotifier.value = await SavedRemotesService.loadSavedRemotes();
                                          },
                                          icon: const Icon(Icons.delete, color: Colors.redAccent),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (_, __) => const SizedBox(width: 12),
                          itemCount: saved.length,
                        ),
                      );
                    },
                  ),

                  const Spacer(),

                  // Bottom quick automation button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const AutomationScreen()),
                        );
                      },
                      icon: const Icon(Icons.schedule),
                      label: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child: Text('Автоматизация сценариев'),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.purpleAccent),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}