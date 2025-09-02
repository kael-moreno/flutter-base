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
