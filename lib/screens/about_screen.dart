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
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Text(
                'TAMK × THWS Collaboration',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 32),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Team',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(height: 10),
            const _MemberCard(
              name: 'Yasas Wijethunga',
              email: 'yasas.wijethunga@tuni.fi',
              institution: 'TAMK',
            ),
            const _MemberCard(
              name: 'Waruna Bandara Rathnamalala',
              email: 'waruna.rathnamalalabandaralage@tuni.fi',
              institution: 'TAMK',
            ),
            const _MemberCard(
              name: 'Maha Maligaspe',
              email: 'maha.maligaspe@tuni.fi',
              institution: 'TAMK',
            ),
            const _MemberCard(
              name: 'Noah Frei',
              email: 'noah.frei@study.thws.de',
              institution: 'THWS',
            ),
            const SizedBox(height: 24),
            const _InfoCard(
              icon: Icons.code,
              label: 'Built with',
              value: 'Flutter & Riverpod',
            ),
            const _InfoCard(
              icon: Icons.api,
              label: 'Data source',
              value: 'TheMealDB API',
            ),
            const SizedBox(height: 24),
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

class _MemberCard extends StatelessWidget {
  final String name;
  final String email;
  final String institution;

  const _MemberCard({
    required this.name,
    required this.email,
    required this.institution,
  });

  @override
  Widget build(BuildContext context) {
    final isThws = institution == 'THWS';
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isThws ? Colors.blue.shade50 : Colors.green.shade50,
          child: Icon(
            Icons.person,
            color: isThws ? Colors.blue.shade600 : Colors.green.shade600,
          ),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(email, style: const TextStyle(fontSize: 12)),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isThws ? Colors.blue.shade50 : Colors.green.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            institution,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: isThws ? Colors.blue.shade700 : Colors.green.shade700,
            ),
          ),
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
