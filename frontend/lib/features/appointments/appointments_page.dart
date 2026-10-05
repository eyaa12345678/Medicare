import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers.dart';

class AppointmentsPage extends ConsumerStatefulWidget {
  const AppointmentsPage({super.key});
  @override
  ConsumerState<AppointmentsPage> createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends ConsumerState<AppointmentsPage> {
  List<dynamic> items = [];
  final doctor = TextEditingController();
  final reason = TextEditingController();

  Future<void> load() async {
    final r = await ref.read(apiClientProvider).dio.get('/appointments');
    setState(() => items = r.data as List<dynamic>);
  }

  Future<void> add() async {
    await ref.read(apiClientProvider).dio.post('/appointments', data: {
      'dateTime': DateTime.now().add(const Duration(days: 1)).toIso8601String(),
      'doctorName': doctor.text,
      'reason': reason.text,
    });
    doctor.clear(); reason.clear(); load();
  }

  Future<void> remove(int id) async {
    await ref.read(apiClientProvider).dio.delete('/appointments/$id');
    load();
  }

  @override
  void initState() { super.initState(); load(); }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Rendez-vous')),
    body: Column(children: [
      Padding(
        padding: const EdgeInsets.all(12),
        child: Row(children: [
          Expanded(child: TextField(controller: doctor, decoration: const InputDecoration(labelText: 'Médecin'))),
          const SizedBox(width: 8),
          Expanded(child: TextField(controller: reason, decoration: const InputDecoration(labelText: 'Motif'))),
          IconButton(onPressed: add, icon: const Icon(Icons.add)),
        ]),
      ),
      Expanded(child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (_, i) {
          final a = items[i];
          return ListTile(
            title: Text(a['doctorName'] ?? ''),
            subtitle: Text('${a['dateTime'] ?? ''}\n${a['reason'] ?? ''}'),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => remove(a['id']),
            ),
          );
        },
      )),
    ]),
  );
}
