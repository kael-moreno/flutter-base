import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/counter.dart';
import '../../domain/repositories/counter_repository.dart';
import '../datasources/counter_local_data_source.dart';

/// Implementation of the CounterRepository
class CounterRepositoryImpl implements CounterRepository {
  final CounterLocalDataSource localDataSource;

  CounterRepositoryImpl({
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, Counter>> getCounter() async {
    try {
      final value = await localDataSource.getCounter();
      final counter = Counter(
        value: value,
        lastUpdated: DateTime.now(),
      );
      return Right(counter);
    } catch (e) {
      return Left(StorageFailure(message: 'Failed to get counter: $e'));
    }
  }

  @override
  Future<Either<Failure, Counter>> incrementCounter() async {
    try {
      final currentValue = await localDataSource.getCounter();
      final newValue = currentValue + 1;
      await localDataSource.saveCounter(newValue);
      
      final counter = Counter(
        value: newValue,
        lastUpdated: DateTime.now(),
      );
      return Right(counter);
    } catch (e) {
      return Left(StorageFailure(message: 'Failed to increment counter: $e'));
    }
  }

  @override
  Future<Either<Failure, Counter>> resetCounter() async {
    try {
      await localDataSource.clearCounter();
      final counter = Counter(
        value: 0,
        lastUpdated: DateTime.now(),
      );
      return Right(counter);
    } catch (e) {
      return Left(StorageFailure(message: 'Failed to reset counter: $e'));
    }
  }

  @override
  Future<Either<Failure, Counter>> setCounter(int value) async {
    try {
      await localDataSource.saveCounter(value);
      final counter = Counter(
        value: value,
        lastUpdated: DateTime.now(),
      );
      return Right(counter);
    } catch (e) {
      return Left(StorageFailure(message: 'Failed to set counter: $e'));
    }
  }
}
