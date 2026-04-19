import 'package:fpdart/fpdart.dart';
import 'package:dio/dio.dart';
import '../errors/failures.dart';
import '../network/api_client.dart';

/// Generic repository for all API operations
/// Eliminates the need for individual repository implementations
class BaseRepository {
  final ApiClient _apiClient;

  BaseRepository(this._apiClient);

  /// Generic GET request for lists
  Future<Either<Failure, List<T>>> getList<T>({
    required String endpoint,
    required T Function(Map<String, dynamic>) fromJson,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final response = await _apiClient.dio.get(
        endpoint,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data is List
            ? response.data
            : response.data['data'] ?? [];

        final List<T> items = jsonList
            .map((json) => fromJson(json as Map<String, dynamic>))
            .toList();

        return Either.right(items);
      } else {
        return Either.left(
          NetworkFailure(
            message: 'Failed to fetch data: ${response.statusCode}',
          ),
        );
      }
    } on DioException catch (e) {
      return Either.left(_handleDioException(e));
    } catch (e) {
      return Either.left(GeneralFailure(message: e.toString()));
    }
  }

  /// Generic GET request for single item
  Future<Either<Failure, T>> getItem<T>({
    required String endpoint,
    required T Function(Map<String, dynamic>) fromJson,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final response = await _apiClient.dio.get(
        endpoint,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = response.data is Map
            ? response.data
            : response.data['data'];

        return Either.right(fromJson(json));
      } else {
        return Either.left(
          NetworkFailure(
            message: 'Failed to fetch item: ${response.statusCode}',
          ),
        );
      }
    } on DioException catch (e) {
      return Either.left(_handleDioException(e));
    } catch (e) {
      return Either.left(GeneralFailure(message: e.toString()));
    }
  }

  /// Generic POST request
  Future<Either<Failure, T>> post<T>({
    required String endpoint,
    required T Function(Map<String, dynamic>) fromJson,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        endpoint,
        data: data,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> json = response.data is Map
            ? response.data
            : response.data['data'];

        return Either.right(fromJson(json));
      } else {
        return Either.left(
          NetworkFailure(
            message: 'Failed to create item: ${response.statusCode}',
          ),
        );
      }
    } on DioException catch (e) {
      return Either.left(_handleDioException(e));
    } catch (e) {
      return Either.left(GeneralFailure(message: e.toString()));
    }
  }

  /// Generic PUT request
  Future<Either<Failure, T>> put<T>({
    required String endpoint,
    required T Function(Map<String, dynamic>) fromJson,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final response = await _apiClient.dio.put(
        endpoint,
        data: data,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = response.data is Map
            ? response.data
            : response.data['data'];

        return Either.right(fromJson(json));
      } else {
        return Either.left(
          NetworkFailure(
            message: 'Failed to update item: ${response.statusCode}',
          ),
        );
      }
    } on DioException catch (e) {
      return Either.left(_handleDioException(e));
    } catch (e) {
      return Either.left(GeneralFailure(message: e.toString()));
    }
  }

  /// Generic DELETE request
  Future<Either<Failure, bool>> delete({
    required String endpoint,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final response = await _apiClient.dio.delete(
        endpoint,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return Either.right(true);
      } else {
        return Either.left(
          NetworkFailure(
            message: 'Failed to delete item: ${response.statusCode}',
          ),
        );
      }
    } on DioException catch (e) {
      return Either.left(_handleDioException(e));
    } catch (e) {
      return Either.left(GeneralFailure(message: e.toString()));
    }
  }

  Failure _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkFailure(message: 'Connection timeout');
      case DioExceptionType.badResponse:
        return NetworkFailure(
          message: 'Server error: ${e.response?.statusCode}',
        );
      case DioExceptionType.cancel:
        return NetworkFailure(message: 'Request cancelled');
      case DioExceptionType.connectionError:
        return NetworkFailure(message: 'No internet connection');
      default:
        return NetworkFailure(message: e.message ?? 'Unknown network error');
    }
  }
}
