import 'package:flutter/material.dart';
import 'remote_control_screen.dart';

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
