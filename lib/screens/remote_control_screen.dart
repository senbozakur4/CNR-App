import 'package:flutter/material.dart';

class RemoteControlScreen extends StatelessWidget {
  final String deviceName;
  final String brand;

  const RemoteControlScreen({
    super.key,
    required this.deviceName,
    required this.brand,
  });

  @override
  Widget build(BuildContext context) {
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

    return Scaffold(
      appBar: AppBar(
        title: Text('$deviceName — $brand'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: buttons.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
          ),
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
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(btn['icon'], size: 30, color: Colors.purpleAccent),
                    const SizedBox(height: 8),
                    Text(
                      btn['label'],
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
