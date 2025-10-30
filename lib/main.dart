import 'package:flutter/material.dart';

void main() {
  runApp(const CnrApp());
}

class CnrApp extends StatelessWidget {
  const CnrApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CNR-App',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const MainScreen(),
    );
  }
}

/// -------------------- ГЛАВНЫЙ ЭКРАН --------------------
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Верхняя панель
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'CNR-App',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                      color: Colors.white,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.star, color: Colors.white, size: 28),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const RemotesScreen()),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.settings, color: Colors.white, size: 28),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SettingsScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Text(
                'Сохранённые пульты',
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
              const SizedBox(height: 20),

              // Пример карточки
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RemotesScreen()),
                  );
                },
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: const Row(
                    children: [
                      Icon(Icons.tv, size: 45, color: Colors.purpleAccent),
                      SizedBox(width: 16),
                      Text(
                        'Телевизор',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// -------------------- СПИСОК КАТЕГОРИЙ УСТРОЙСТВ --------------------
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

/// -------------------- ВЫБОР БРЕНДА --------------------
class BrandSelectionScreen extends StatelessWidget {
  final String deviceName;
  const BrandSelectionScreen({super.key, required this.deviceName});

  @override
  Widget build(BuildContext context) {
    final Map<String, List<String>> brands = {
      'Television': ['Samsung', 'LG', 'Sony', 'Panasonic', 'Philips', 'TCL', 'Xiaomi'],
      'PC': ['Dell', 'HP', 'Asus', 'Acer', 'Lenovo'],
      'Proektor': ['Epson', 'BenQ', 'ViewSonic', 'LG'],
      'Kamera': ['Canon', 'Nikon', 'Sony', 'Fujifilm'],
      'Ventilation': ['Midea', 'LG', 'Gree', 'Daikin'],
      'Condition': ['Samsung', 'LG', 'Haier', 'Hisense'],
      'Pristavka': ['PlayStation', 'Xbox', 'Nintendo', 'Mi Box'],
    };

    final deviceBrands = brands[deviceName] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text('Выберите бренд: $deviceName'),
        backgroundColor: Colors.black,
      ),
      body: ListView.builder(
        itemCount: deviceBrands.length,
        itemBuilder: (context, index) {
          final brand = deviceBrands[index];
          return ListTile(
            title: Text(brand, style: const TextStyle(color: Colors.white)),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RemoteControlScreen(
                    deviceName: deviceName,
                    brand: brand,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

/// -------------------- ИНТЕРФЕЙС ПУЛЬТА --------------------
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

/// -------------------- ЭКРАН НАСТРОЕК --------------------
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> settings = [
      'Тема приложения',
      'Язык интерфейса',
      'Уведомления',
      'О приложении',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки'),
        backgroundColor: Colors.black,
      ),
      body: ListView.builder(
        itemCount: settings.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(settings[index], style: const TextStyle(color: Colors.white)),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 16),
            onTap: () {},
          );
        },
      ),
    );
  }
}
