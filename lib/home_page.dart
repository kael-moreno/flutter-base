import 'package:flutter/material.dart';
import '../features/counter/presentation/pages/counter_page.dart';
import '../features/users/presentation/pages/users_page.dart';

/// Home page with navigation to different features
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clean Architecture Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Welcome to Clean Architecture Demo',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'This app demonstrates Clean Architecture with Riverpod state management',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            _buildFeatureCard(
              context,
              title: 'Counter Feature',
              description: 'Local state management with persistence',
              icon: Icons.add_circle_outline,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CounterPage()),
              ),
            ),
            const SizedBox(height: 16),
            _buildFeatureCard(
              context,
              title: 'Users Feature',
              description: 'API integration with Dio HTTP client',
              icon: Icons.people_outline,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UsersPage()),
              ),
            ),
            const SizedBox(height: 32),
            const Expanded(
              child: _ArchitectureInfo(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(
                icon,
                size: 48,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios),
            ],
          ),
        ),
      ),
    );
  }
}

class _ArchitectureInfo extends StatelessWidget {
  const _ArchitectureInfo();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Architecture Layers',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            _buildLayerInfo(
              context,
              '📱 Presentation',
              'UI, Widgets, State Management (Riverpod)',
            ),
            _buildLayerInfo(
              context,
              '🏛️ Domain',
              'Business Logic, Entities, Use Cases',
            ),
            _buildLayerInfo(
              context,
              '💾 Data',
              'API Calls (Dio), Local Storage, Repositories',
            ),
            const SizedBox(height: 12),
            Text(
              'Technologies: Flutter • Riverpod • Dio • Clean Architecture',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLayerInfo(BuildContext context, String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              description,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
