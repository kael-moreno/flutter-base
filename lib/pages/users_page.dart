import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../core/api/api_service.dart';

// Complete Users API integration in just 3 lines!
final usersProvider = ApiServiceFactory.createListProvider<User>(
  ApiConfig<User>(endpoint: '/users', fromJson: (json) => User.fromJson(json)),
);

class UsersPage extends ConsumerWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersState = ref.watch(usersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => ref.read(usersProvider.notifier).refresh(),
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Users',
          ),
        ],
      ),
      body: Column(
        children: [
          // Status indicator
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Text(
              usersState.isLoading
                  ? '⏳ Loading users...'
                  : usersState.error != null
                  ? '❌ Error: ${usersState.error}'
                  : '✅ ${usersState.items.length} users loaded',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: usersState.error != null
                    ? Theme.of(context).colorScheme.error
                    : Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Content
          Expanded(
            child: usersState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : usersState.error != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error loading users',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          usersState.error!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () =>
                              ref.read(usersProvider.notifier).loadData(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: () => ref.read(usersProvider.notifier).refresh(),
                    child: ListView.builder(
                      itemCount: usersState.items.length,
                      itemBuilder: (context, index) {
                        final user = usersState.items[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          child: ExpansionTile(
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                              child: Text(
                                user.name.substring(0, 1),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(
                              user.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('👤 @${user.username}'),
                                Text('✉️ ${user.email}'),
                                Text('🏢 ${user.company.name}'),
                              ],
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildDetailRow('📧 Email', user.email),
                                    _buildDetailRow('📞 Phone', user.phone),
                                    _buildDetailRow('🌐 Website', user.website),
                                    const SizedBox(height: 12),
                                    Text(
                                      '🏠 Address',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text('   ${user.address.fullAddress}'),
                                    const SizedBox(height: 12),
                                    Text(
                                      '🏢 Company',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text('   ${user.company.name}'),
                                    Text(
                                      '   "${user.company.catchPhrase}"',
                                      style: const TextStyle(
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    Text('   ${user.company.bs}'),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ElevatedButton.icon(
                                          onPressed: () {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Calling ${user.name}...',
                                                ),
                                              ),
                                            );
                                          },
                                          icon: const Icon(Icons.phone),
                                          label: const Text('Call'),
                                        ),
                                        ElevatedButton.icon(
                                          onPressed: () {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Opening ${user.website}...',
                                                ),
                                              ),
                                            );
                                          },
                                          icon: const Icon(Icons.web),
                                          label: const Text('Website'),
                                        ),
                                        ElevatedButton.icon(
                                          onPressed: () =>
                                              _showUserDetails(context, user),
                                          icon: const Icon(Icons.info_outline),
                                          label: const Text('Details'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateUserDialog(context, ref),
        tooltip: 'Add New User',
        child: const Icon(Icons.person_add),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _showUserDetails(BuildContext context, User user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(user.name),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ID: ${user.id}'),
              Text('Username: @${user.username}'),
              Text('Email: ${user.email}'),
              Text('Phone: ${user.phone}'),
              Text('Website: ${user.website}'),
              const SizedBox(height: 8),
              Text('Address: ${user.address.fullAddress}'),
              const SizedBox(height: 8),
              Text('Company: ${user.company.name}'),
              Text('Motto: "${user.company.catchPhrase}"'),
              Text('Business: ${user.company.bs}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showCreateUserDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New User'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                hintText: 'Enter user name',
              ),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'Enter email address',
              ),
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  emailController.text.isNotEmpty) {
                ref.read(usersProvider.notifier).create({
                  'name': nameController.text,
                  'email': emailController.text,
                  'username': nameController.text.toLowerCase().replaceAll(
                    ' ',
                    '',
                  ),
                  'phone': '1-555-000-0000',
                  'website': 'example.com',
                  'address': {
                    'street': 'Main Street',
                    'suite': 'Suite 1',
                    'city': 'City',
                    'zipcode': '12345',
                    'geo': {'lat': '0.0', 'lng': '0.0'},
                  },
                  'company': {
                    'name': 'New Company',
                    'catchPhrase': 'Innovation first',
                    'bs': 'synergize solutions',
                  },
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('User created successfully!')),
                );
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}
