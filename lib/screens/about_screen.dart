import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About EcoPlate')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            CircleAvatar(
              radius: 48,
              backgroundColor: Colors.green.shade100,
              child: Icon(Icons.eco, size: 48, color: Colors.green.shade700),
            ),
            const SizedBox(height: 20),
            Text(
              'EcoPlate',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Eco-Friendly Recipe & Meal Planner',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Colors.grey,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            const _InfoCard(
              icon: Icons.person,
              label: 'Developer',
              value: 'Yasas Wijethunga',
            ),
            const _InfoCard(
              icon: Icons.email,
              label: 'Email',
              value: 'yasastw@gmail.com',
            ),
            const _InfoCard(
              icon: Icons.school,
              label: 'Institution',
              value: 'Tampere University of Applied Sciences (TAMK)',
            ),
            const _InfoCard(
              icon: Icons.code,
              label: 'Built with',
              value: 'Flutter & Riverpod',
            ),
            const SizedBox(height: 32),
            Text(
              'EcoPlate helps you discover and plan eco-friendly meals '
              'sourced from plant-based and sustainable ingredient categories. '
              'Recipe data is powered by TheMealDB API.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.6,
                    color: Colors.grey.shade600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icon, color: Colors.green),
        title: Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        subtitle: Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
      ),
    );
  }
}
