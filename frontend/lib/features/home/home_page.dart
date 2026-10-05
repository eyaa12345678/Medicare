import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../appointments/appointments_page.dart';
import '../auth/authentication_state.dart';
import '../health/health_page.dart';
import '../medications/medications_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authenticationStateProvider).valueOrNull;

    return Scaffold(
      appBar: AppBar(
        title: const Text('MediCare'),
        actions: [
          IconButton(
            tooltip: 'Profil',
            onPressed: () => Navigator.pushNamed(context, '/profile'),
            icon: const Icon(Icons.account_circle_outlined),
          ),
          IconButton(
            tooltip: 'Deconnexion',
            onPressed: () async {
              await ref.read(authenticationStateProvider.notifier).logout();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
              }
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            user == null ? 'Bienvenue dans MediCare' : 'Bonjour ${user.fullName}',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          _tile(context, Icons.calendar_today, 'Rendez-vous', const AppointmentsPage()),
          _tile(context, Icons.medication_outlined, 'Medicaments', const MedicationsPage()),
          _tile(context, Icons.favorite_border, 'Suivi sante', const HealthPage()),
        ],
      ),
    );
  }

  Widget _tile(BuildContext context, IconData icon, String title, Widget page) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
      ),
    );
  }
}
