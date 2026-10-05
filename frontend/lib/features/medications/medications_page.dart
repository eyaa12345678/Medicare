import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers.dart';

class MedicationsPage extends ConsumerStatefulWidget {
  const MedicationsPage({super.key});
  @override
  ConsumerState<MedicationsPage> createState() => _MedicationsPageState();
}

class _MedicationsPageState extends ConsumerState<MedicationsPage> {
  List<dynamic> items = [];
  final name = TextEditingController();
  final dosage = TextEditingController();

  Future<void> load() async {
    final r = await ref.read(apiClientProvider).dio.get('/medications');
    setState(() => items = r.data as List<dynamic>);
  }

  Future<void> add() async {
    await ref.read(apiClientProvider).dio.post('/medications', data: {
      'name': name.text, 'dosage': dosage.text,
      'frequency': '1 fois/jour', 'instructions': '',
    });
    name.clear(); dosage.clear(); load();
  }

  Future<void> remove(int id) async {
    await ref.read(apiClientProvider).dio.delete('/medications/$id');
    load();
  }

  @override
  void initState() { super.initState(); load(); }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Médicaments')),
    body: Column(children: [
      Padding(
        padding: const EdgeInsets.all(12),
        child: Row(children: [
          Expanded(child: TextField(controller: name, decoration: const InputDecoration(labelText: 'Médicament'))),
          const SizedBox(width: 8),
          Expanded(child: TextField(controller: dosage, decoration: const InputDecoration(labelText: 'Dosage'))),
          IconButton(onPressed: add, icon: const Icon(Icons.add)),
        ]),
      ),
      Expanded(child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (_, i) {
          final m = items[i];
          return ListTile(
            title: Text(m['name'] ?? ''),
            subtitle: Text('${m['dosage'] ?? ''} - ${m['frequency'] ?? ''}'),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => remove(m['id']),
            ),
          );
        },
      )),
    ]),
  );
}
