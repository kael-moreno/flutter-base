import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/counter.dart';
import '../repositories/counter_repository.dart';

/// Use case for resetting the counter
class ResetCounter implements NoParamsUseCase<Counter> {
  final CounterRepository repository;

  ResetCounter(this.repository);

  @override
  Future<Either<Failure, Counter>> call() async {
    return await repository.resetCounter();
  }
}
