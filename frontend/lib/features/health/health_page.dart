import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers.dart';

class HealthPage extends ConsumerStatefulWidget {
  const HealthPage({super.key});
  @override
  ConsumerState<HealthPage> createState() => _HealthPageState();
}

class _HealthPageState extends ConsumerState<HealthPage> {
  List<dynamic> items = [];
  final weight = TextEditingController();
  final heartRate = TextEditingController();

  Future<void> load() async {
    final r = await ref.read(apiClientProvider).dio.get('/health-records');
    setState(() => items = r.data as List<dynamic>);
  }

  Future<void> add() async {
    await ref.read(apiClientProvider).dio.post('/health-records', data: {
      'recordedAt': DateTime.now().toIso8601String(),
      'weight': double.tryParse(weight.text),
      'heartRate': int.tryParse(heartRate.text),
    });
    weight.clear(); heartRate.clear(); load();
  }

  Future<void> remove(int id) async {
    await ref.read(apiClientProvider).dio.delete('/health-records/$id');
    load();
  }

  @override
  void initState() { super.initState(); load(); }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Suivi santé')),
    body: Column(children: [
      Padding(
        padding: const EdgeInsets.all(12),
        child: Row(children: [
          Expanded(child: TextField(controller: weight, keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Poids (kg)'))),
          const SizedBox(width: 8),
          Expanded(child: TextField(controller: heartRate, keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Pouls'))),
          IconButton(onPressed: add, icon: const Icon(Icons.add)),
        ]),
      ),
      Expanded(child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (_, i) {
          final h = items[i];
          return ListTile(
            title: Text('Poids: ${h['weight'] ?? '-'} kg'),
            subtitle: Text('Pouls: ${h['heartRate'] ?? '-'} bpm'),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => remove(h['id']),
            ),
          );
        },
      )),
    ]),
  );
}
