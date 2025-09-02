import 'package:dio/dio.dart';

/// HTTP client configuration for the application
class ApiClient {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    
    _setupInterceptors();
  }

  Dio get dio => _dio;

  void _setupInterceptors() {
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        responseHeader: false,
        error: true,
      ),
    );
    
    // Add error handling interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) {
          // Log error details
          print('API Error: ${error.message}');
          print('Status Code: ${error.response?.statusCode}');
          handler.next(error);
        },
      ),
    );
  }
}
