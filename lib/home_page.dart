import 'package:flutter/material.dart';
import '../pages/posts_page.dart';
import '../pages/users_page.dart';

/// Home page with navigation to different features
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clean Architecture Demo')),
      body: SingleChildScrollView(
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
              title: 'Users Demo',
              description:
                  'Rich user data with expandable details and actions!',
              icon: Icons.people_outlined,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UsersPage()),
              ),
            ),
            const SizedBox(height: 16),
            _buildFeatureCard(
              context,
              title: 'Posts Demo',
              description:
                  'Complete API integration with unified architecture!',
              icon: Icons.article_outlined,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PostsPage()),
              ),
            ),
            const SizedBox(height: 32),
            const _ArchitectureInfo(),
            const SizedBox(
              height: 32,
            ), // Extra padding at bottom for better scrolling
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
              '🚀 Unified API Architecture',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildLayerInfo(
              context,
              '📱 Pages',
              'UI + Provider in one file - No folders needed!',
            ),
            _buildLayerInfo(
              context,
              '📄 Models',
              'Simple data models with fromJson/toJson',
            ),
            _buildLayerInfo(
              context,
              '⚙️ Core',
              'Unified API service handles all CRUD operations',
            ),
            const SizedBox(height: 12),
            Text(
              '90% less boilerplate • 2 files per API • Clean Architecture benefits',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLayerInfo(
    BuildContext context,
    String title,
    String description,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
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
