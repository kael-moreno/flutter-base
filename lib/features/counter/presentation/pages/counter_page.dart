import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/counter_state_provider.dart';
import '../widgets/counter_display.dart';
import '../widgets/counter_actions.dart';

/// Counter page following Clean Architecture
class CounterPage extends ConsumerWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counterState = ref.watch(counterNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Clean Architecture Counter'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            onPressed: () => ref.read(counterNotifierProvider.notifier).reset(),
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset Counter',
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (counterState.isLoading) ...[
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              const Text('Loading counter...'),
            ] else if (counterState.error != null) ...[
              Icon(
                Icons.error_outline,
                color: Theme.of(context).colorScheme.error,
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                'Error: ${counterState.error}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.read(counterNotifierProvider.notifier).loadCounter(),
                child: const Text('Retry'),
              ),
            ] else ...[
              const CounterDisplay(),
              const SizedBox(height: 32),
              const CounterActions(),
            ],
          ],
        ),
      ),
      floatingActionButton: counterState.isLoading || counterState.error != null
          ? null
          : FloatingActionButton(
              onPressed: () => ref.read(counterNotifierProvider.notifier).increment(),
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            ),
    );
  }
}
