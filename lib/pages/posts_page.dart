import 'package:flutter/material.dart';
import 'package:flutter_app/core/baseui/error_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/providers/api_providers.dart';

class PostsPage extends ConsumerWidget {
  const PostsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsState = ref.watch(ApiProviders.postsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: postsState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : postsState.error != null
          ? ErrorApiWidget(
              errorMessage: postsState.error!,
              onRetry: () {
                ref.invalidate(ApiProviders.postsProvider);
              },
            )
          : RefreshIndicator(
              onRefresh: () =>
                  ref.read(ApiProviders.postsProvider.notifier).refresh(),
              child: ListView.builder(
                itemCount: postsState.items.length,
                itemBuilder: (context, index) {
                  final post = postsState.items[index];
                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post.title,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            post.body,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Chip(
                                label: Text('Post #${post.id}'),
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.primaryContainer,
                              ),
                              Chip(
                                label: Text('User ${post.userId}'),
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.secondaryContainer,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
