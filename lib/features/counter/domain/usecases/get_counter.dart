import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/counter.dart';
import '../repositories/counter_repository.dart';

/// Use case for getting the current counter value
class GetCounter implements NoParamsUseCase<Counter> {
  final CounterRepository repository;

  GetCounter(this.repository);

  @override
  Future<Either<Failure, Counter>> call() async {
    return await repository.getCounter();
  }
}
