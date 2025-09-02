import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/counter.dart';
import '../../domain/usecases/get_counter.dart';
import '../../domain/usecases/increment_counter.dart';
import '../../domain/usecases/reset_counter.dart';
import 'counter_providers.dart';

/// State for the counter feature
class CounterState {
  final Counter? counter;
  final bool isLoading;
  final String? error;

  const CounterState({
    this.counter,
    this.isLoading = false,
    this.error,
  });

  CounterState copyWith({
    Counter? counter,
    bool? isLoading,
    String? error,
  }) {
    return CounterState(
      counter: counter ?? this.counter,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// StateNotifier for managing counter state
class CounterNotifier extends StateNotifier<CounterState> {
  final GetCounter getCounter;
  final IncrementCounter incrementCounter;
  final ResetCounter resetCounter;

  CounterNotifier({
    required this.getCounter,
    required this.incrementCounter,
    required this.resetCounter,
  }) : super(const CounterState()) {
    loadCounter();
  }

  /// Load the initial counter value
  Future<void> loadCounter() async {
    state = state.copyWith(isLoading: true, error: null);
    
    final result = await getCounter();
    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.message,
      ),
      (counter) => state = state.copyWith(
        isLoading: false,
        counter: counter,
        error: null,
      ),
    );
  }

  /// Increment the counter
  Future<void> increment() async {
    final result = await incrementCounter();
    result.fold(
      (failure) => state = state.copyWith(error: failure.message),
      (counter) => state = state.copyWith(counter: counter, error: null),
    );
  }

  /// Reset the counter
  Future<void> reset() async {
    final result = await resetCounter();
    result.fold(
      (failure) => state = state.copyWith(error: failure.message),
      (counter) => state = state.copyWith(counter: counter, error: null),
    );
  }
}

/// Provider for the counter state notifier
final counterNotifierProvider =
    StateNotifierProvider<CounterNotifier, CounterState>((ref) {
  return CounterNotifier(
    getCounter: ref.read(getCounterUseCaseProvider),
    incrementCounter: ref.read(incrementCounterUseCaseProvider),
    resetCounter: ref.read(resetCounterUseCaseProvider),
  );
});
