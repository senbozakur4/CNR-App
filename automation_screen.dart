import 'dart:async';
import 'package:flutter/material.dart';

class AutomationScreen extends StatefulWidget {
  const AutomationScreen({super.key});

  @override
  State<AutomationScreen> createState() => _AutomationScreenState();
}

class _AutomationScreenState extends State<AutomationScreen> {
  final List<Map<String, dynamic>> _tasks = [];

  void _addTask() async {
    // simple example: schedule a Power command in X seconds
    final result = await showDialog<int>(context: context, builder: (context) {
      int seconds = 10;
      return AlertDialog(
        title: const Text('Добавить задачу'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Через сколько секунд выполнить команду Power всем сохранённым пультам?'),
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (v) { seconds = int.tryParse(v) ?? 10; },
              decoration: const InputDecoration(hintText: '10'),
            )
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Отмена')),
          TextButton(onPressed: () => Navigator.pop(context, seconds), child: const Text('Добавить')),
        ],
      );
    });

    if (result != null) {
      final task = {'id': DateTime.now().millisecondsSinceEpoch, 'delay': result};
      setState(() => _tasks.add(task));

      Timer(Duration(seconds: result), () {
        // Выполните действие (например: Power всем сохранённым пультам)
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Автозадача выполнена: Power всем сохранённым пультам (${_tasks.where((t) => t['id'] == task['id']).isNotEmpty})')));
        setState(() => _tasks.removeWhere((t) => t['id'] == task['id']));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Автоматизация сценариев'), backgroundColor: Colors.black),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            ElevatedButton.icon(onPressed: _addTask, icon: const Icon(Icons.add), label: const Text('Добавить задачу')),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  final t = _tasks[index];
                  return Card(
                    child: ListTile(
                      title: Text('Задача #${t['id']}', style: const TextStyle(color: Colors.black)),
                      subtitle: Text('Через ${t['delay']} сек'),
                      trailing: IconButton(onPressed: () { setState(() => _tasks.removeAt(index)); }, icon: const Icon(Icons.delete)),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}