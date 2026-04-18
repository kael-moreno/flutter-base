import 'package:fpdart/fpdart.dart';
import '../network/api_client.dart';
import '../data/base_repository.dart';
import '../errors/failures.dart';

/// Simple API configuration for each endpoint
class ApiConfig<T> {
  /// Base endpoint path (e.g., '/users')
  final String endpoint;

  /// Function to convert JSON to your model
  final T Function(Map<String, dynamic>) fromJson;

  /// Optional: Function to convert your model to JSON for POST/PUT
  final Map<String, dynamic> Function(T)? toJson;

  /// Optional: Function to get unique identifier from model (for updates/deletes)
  final dynamic Function(T)? getId;

  const ApiConfig({
    required this.endpoint,
    required this.fromJson,
    this.toJson,
    this.getId,
  });
}

/// Generic API service that handles all CRUD operations
class ApiService<T> {
  final BaseRepository _repository;
  final ApiConfig<T> _config;

  ApiService(this._repository, this._config);

  /// Get all items
  Future<Either<Failure, List<T>>> getAll({Map<String, dynamic>? queryParams}) {
    return _repository.getList<T>(
      endpoint: _config.endpoint,
      fromJson: _config.fromJson,
      queryParams: queryParams,
    );
  }

  /// Get single item by ID
  Future<Either<Failure, T>> getById(
    dynamic id, {
    Map<String, dynamic>? queryParams,
  }) {
    return _repository.getItem<T>(
      endpoint: '${_config.endpoint}/$id',
      fromJson: _config.fromJson,
      queryParams: queryParams,
    );
  }

  /// Create new item
  Future<Either<Failure, T>> create(T item) {
    if (_config.toJson == null) {
      return Future.value(
        Either.left(
          ValidationFailure(
            message: 'toJson function not provided for create operation',
          ),
        ),
      );
    }

    return _repository.post<T>(
      endpoint: _config.endpoint,
      fromJson: _config.fromJson,
      data: _config.toJson!(item),
    );
  }

  /// Update existing item
  Future<Either<Failure, T>> update(T item) {
    if (_config.toJson == null || _config.getId == null) {
      return Future.value(
        Either.left(
          ValidationFailure(
            message: 'toJson and getId functions required for update operation',
          ),
        ),
      );
    }

    final id = _config.getId!(item);
    return _repository.put<T>(
      endpoint: '${_config.endpoint}/$id',
      fromJson: _config.fromJson,
      data: _config.toJson!(item),
    );
  }

  /// Delete item
  Future<Either<Failure, bool>> delete(T item) {
    if (_config.getId == null) {
      return Future.value(
        Either.left(
          ValidationFailure(
            message: 'getId function required for delete operation',
          ),
        ),
      );
    }

    final id = _config.getId!(item);
    return _repository.delete(endpoint: '${_config.endpoint}/$id');
  }
}

/// Factory to create API services with minimal boilerplate
class ApiServiceFactory {
  static final _repository = BaseRepository(ApiClient());

  /// Create a simple read-only API service (GET operations only)
  static ApiService<T> createReadOnly<T>(ApiConfig<T> config) {
    return ApiService<T>(_repository, config);
  }

  /// Create a full CRUD API service
  static ApiService<T> createCRUD<T>(ApiConfig<T> config) {
    return ApiService<T>(_repository, config);
  }
}
