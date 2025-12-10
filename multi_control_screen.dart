import 'package:flutter/material.dart';
import '../main.dart';

class MultiControlScreen extends StatefulWidget {
  const MultiControlScreen({super.key});

  @override
  State<MultiControlScreen> createState() => _MultiControlScreenState();
}

class _MultiControlScreenState extends State<MultiControlScreen> {
  final Set<int> _selected = {};

  @override
  Widget build(BuildContext context) {
    final saved = savedRemotesNotifier.value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Управление несколькими пультами'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: saved.length,
                itemBuilder: (context, index) {
                  final r = saved[index];
                  final sel = _selected.contains(index);
                  return ListTile(
                    tileColor: sel ? Colors.purpleAccent.withOpacity(0.12) : null,
                    title: Text('${r['device']} — ${r['brand']}', style: const TextStyle(color: Colors.white)),
                    leading: Checkbox(
                      value: sel,
                      onChanged: (v) {
                        setState(() {
                          if (v == true) {
                            _selected.add(index);
                          } else {
                            _selected.remove(index);
                          }
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            ElevatedButton.icon(
              onPressed: _selected.isEmpty ? null : () {
                // send a sample command to all selected remotes (Power toggle)
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Команда Power отправлена на ${_selected.length} пультов')));
              },
              icon: const Icon(Icons.power_settings_new),
              label: const Padding(padding: EdgeInsets.symmetric(vertical: 14), child: Text('Power всем выделенным')),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purpleAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
            )
          ],
        ),
      ),
    );
  }
}