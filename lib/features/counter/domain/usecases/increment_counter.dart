import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/counter.dart';
import '../repositories/counter_repository.dart';

/// Use case for incrementing the counter
class IncrementCounter implements NoParamsUseCase<Counter> {
  final CounterRepository repository;

  IncrementCounter(this.repository);

  @override
  Future<Either<Failure, Counter>> call() async {
    return await repository.incrementCounter();
  }
}
