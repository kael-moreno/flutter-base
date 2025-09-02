import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';

/// Abstract repository for user operations
abstract class UserRepository {
  /// Get all users from the API
  Future<Either<Failure, List<User>>> getUsers();
  
  /// Get a specific user by ID
  Future<Either<Failure, User>> getUserById(int id);
}
