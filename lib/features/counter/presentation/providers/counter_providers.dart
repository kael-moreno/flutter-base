import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/counter_local_data_source.dart';
import '../../data/repositories/counter_repository_impl.dart';
import '../../domain/repositories/counter_repository.dart';
import '../../domain/usecases/get_counter.dart';
import '../../domain/usecases/increment_counter.dart';
import '../../domain/usecases/reset_counter.dart';

/// Provider for the local data source
final counterLocalDataSourceProvider = Provider<CounterLocalDataSource>((ref) {
  return CounterLocalDataSourceImpl();
});

/// Provider for the counter repository
final counterRepositoryProvider = Provider<CounterRepository>((ref) {
  return CounterRepositoryImpl(
    localDataSource: ref.read(counterLocalDataSourceProvider),
  );
});

/// Provider for get counter use case
final getCounterUseCaseProvider = Provider<GetCounter>((ref) {
  return GetCounter(ref.read(counterRepositoryProvider));
});

/// Provider for increment counter use case
final incrementCounterUseCaseProvider = Provider<IncrementCounter>((ref) {
  return IncrementCounter(ref.read(counterRepositoryProvider));
});

/// Provider for reset counter use case
final resetCounterUseCaseProvider = Provider<ResetCounter>((ref) {
  return ResetCounter(ref.read(counterRepositoryProvider));
});

/// Simple implementation of CounterLocalDataSource using in-memory storage
class CounterLocalDataSourceImpl implements CounterLocalDataSource {
  static int _counter = 0;

  @override
  Future<int> getCounter() async {
    // Simulate async operation
    await Future.delayed(const Duration(milliseconds: 100));
    return _counter;
  }

  @override
  Future<void> saveCounter(int value) async {
    // Simulate async operation
    await Future.delayed(const Duration(milliseconds: 100));
    _counter = value;
  }

  @override
  Future<void> clearCounter() async {
    // Simulate async operation
    await Future.delayed(const Duration(milliseconds: 100));
    _counter = 0;
  }
}
