import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/counter_state_provider.dart';

/// Widget to display the counter value
class CounterDisplay extends ConsumerWidget {
  const CounterDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counterState = ref.watch(counterNotifierProvider);
    final counter = counterState.counter;

    return Column(
      children: [
        const Text(
          'You have pushed the button this many times:',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 16),
        Text(
          '${counter?.value ?? 0}',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        if (counter?.lastUpdated != null) ...[
          const SizedBox(height: 8),
          Text(
            'Last updated: ${_formatDateTime(counter!.lastUpdated)}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ],
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:'
        '${dateTime.minute.toString().padLeft(2, '0')}:'
        '${dateTime.second.toString().padLeft(2, '0')}';
  }
}
