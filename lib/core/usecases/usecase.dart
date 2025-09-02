import 'package:dartz/dartz.dart';
import '../errors/failures.dart';

/// Abstract base class for all use cases
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Use case for operations that don't require parameters
abstract class NoParamsUseCase<Type> {
  Future<Either<Failure, Type>> call();
}

/// Empty params class for use cases that don't need parameters
class NoParams {}
