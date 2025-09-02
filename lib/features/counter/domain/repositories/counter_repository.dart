import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/counter.dart';

/// Abstract repository for counter operations
abstract class CounterRepository {
  /// Get the current counter value
  Future<Either<Failure, Counter>> getCounter();
  
  /// Increment the counter by 1
  Future<Either<Failure, Counter>> incrementCounter();
  
  /// Reset the counter to 0
  Future<Either<Failure, Counter>> resetCounter();
  
  /// Set the counter to a specific value
  Future<Either<Failure, Counter>> setCounter(int value);
}
