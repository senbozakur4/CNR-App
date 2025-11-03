import 'package:flutter/material.dart';
import 'brand_selection_screen.dart';

class RemotesScreen extends StatelessWidget {
  const RemotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> devices = [
      {'title': 'Television', 'icon': Icons.tv},
      {'title': 'PC', 'icon': Icons.computer},
      {'title': 'Proektor', 'icon': Icons.videocam},
      {'title': 'Kamera', 'icon': Icons.photo_camera},
      {'title': 'Ventilation', 'icon': Icons.air},
      {'title': 'Condition', 'icon': Icons.ac_unit},
      {'title': 'Pristavka', 'icon': Icons.gamepad},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Пульты'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.builder(
          itemCount: devices.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
          ),
          itemBuilder: (context, index) {
            final device = devices[index];
            return InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BrandSelectionScreen(
                      deviceName: device['title'],
                    ),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(device['icon'], size: 50, color: Colors.purpleAccent),
                    const SizedBox(height: 10),
                    Text(
                      device['title'],
                      style: const TextStyle(color: Colors.white),
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
