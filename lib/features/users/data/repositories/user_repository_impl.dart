import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_data_source.dart';

/// Implementation of the UserRepository
class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<User>>> getUsers() async {
    try {
      final users = await remoteDataSource.getUsers();
      return Right(users);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, User>> getUserById(int id) async {
    try {
      final user = await remoteDataSource.getUserById(id);
      return Right(user);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  Failure _mapExceptionToFailure(dynamic exception) {
    final String message = exception.toString();
    
    if (message.contains('timeout') || message.contains('connection')) {
      return NetworkFailure(message: 'Network connection failed. Please check your internet connection.');
    } else if (message.contains('404')) {
      return NetworkFailure(message: 'The requested resource was not found.');
    } else if (message.contains('500')) {
      return NetworkFailure(message: 'Server error occurred. Please try again later.');
    } else if (message.contains('SSL') || message.contains('certificate')) {
      return NetworkFailure(message: 'Security certificate error.');
    } else {
      return GeneralFailure(message: 'An unexpected error occurred: $message');
    }
  }
}
