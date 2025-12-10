import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../main.dart';
import '../services/saved_remotes_service.dart';

class RemoteControlScreen extends StatefulWidget {
  final String deviceName;
  final String brand;
  const RemoteControlScreen({super.key, required this.deviceName, required this.brand});

  @override
  State<RemoteControlScreen> createState() => _RemoteControlScreenState();
}

class _RemoteControlScreenState extends State<RemoteControlScreen> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _lastWords = '';
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  final List<Map<String, dynamic>> buttons = [
    {'icon': Icons.power_settings_new, 'label': 'Power'},
    {'icon': Icons.volume_up, 'label': 'Vol +'},
    {'icon': Icons.volume_down, 'label': 'Vol -'},
    {'icon': Icons.keyboard_arrow_up, 'label': 'Up'},
    {'icon': Icons.keyboard_arrow_down, 'label': 'Down'},
    {'icon': Icons.keyboard_arrow_left, 'label': 'Left'},
    {'icon': Icons.keyboard_arrow_right, 'label': 'Right'},
    {'icon': Icons.check, 'label': 'OK'},
    {'icon': Icons.menu, 'label': 'Menu'},
    {'icon': Icons.home, 'label': 'Home'},
    {'icon': Icons.settings, 'label': 'Settings'},
    {'icon': Icons.exit_to_app, 'label': 'Exit'},
  ];

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _initNotifications();
  }

  Future<void> _initNotifications() async {
    const initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    await _notificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _showNotification(String title, String body) async {
    const androidDetails = AndroidNotificationDetails('cnr_channel', 'CNR Notifications', importance: Importance.high);
    const details = NotificationDetails(android: androidDetails);
    await _notificationsPlugin.show(0, title, body, details);
  }

  void _toggleListening() async {
    if (!_isListening) {
      final available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        await _showNotification('Голосовое управление', 'Голосовое управление включено для ${widget.deviceName}');
        _speech.listen(onResult: (result) {
          setState(() {
            _lastWords = result.recognizedWords;
          });
          _handleVoiceCommand(_lastWords);
        });
      }
    } else {
      _speech.stop();
      setState(() => _isListening = false);
      await _showNotification('Голосовое управление', 'Голосовое управление отключено');
    }
  }

  void _handleVoiceCommand(String words) {
    // Простейшая интерпретация команд — можно расширять
    final w = words.toLowerCase();
    if (w.contains('включи') || w.contains('включить') || w.contains('on')) {
      _pressButtonByLabel('Power');
    } else if (w.contains('громче') || w.contains('increase') || w.contains('volume up')) {
      _pressButtonByLabel('Vol +');
    } else if (w.contains('тише') || w.contains('decrease') || w.contains('volume down')) {
      _pressButtonByLabel('Vol -');
    }
  }

  void _pressButtonByLabel(String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Команда: $label'), duration: const Duration(milliseconds: 600)),
    );

    // Здесь место для реальной отправки команды на IR / Wi-Fi / API
  }

  Future<void> _saveThisRemote() async {
    final remote = {'device': widget.deviceName, 'brand': widget.brand};
    await SavedRemotesService.addRemote(remote);
    savedRemotesNotifier.value = await SavedRemotesService.loadSavedRemotes();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Пульт сохранён')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.deviceName} — ${widget.brand}'),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveThisRemote,
          ),
          IconButton(
            icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
            onPressed: _toggleListening,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: buttons.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, crossAxisSpacing: 14, mainAxisSpacing: 14),
          itemBuilder: (context, index) {
            final btn = buttons[index];
            return InkWell(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Нажата кнопка: ${btn['label']}'),
                    duration: const Duration(milliseconds: 500),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Colors.purpleAccent.withOpacity(0.15), Colors.transparent]),
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.purple.withOpacity(0.3),
                        blurRadius: 6,
                        offset: const Offset(2, 2)),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(btn['icon'], size: 30, color: Colors.purpleAccent),
                    const SizedBox(height: 8),
                    Text(btn['label'], style: const TextStyle(color: Colors.white70, fontSize: 13)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: _isListening
          ? Container(
              color: Colors.purpleAccent.withOpacity(0.12),
              padding: const EdgeInsets.all(12),
              child: Text('Слушаю: $_lastWords', style: const TextStyle(color: Colors.white)),
            )
          : null,
    );
  }
}