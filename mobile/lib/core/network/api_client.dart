import 'package:dio/dio.dart';
import 'package:frontend/core/config/api_config.dart';
import 'package:frontend/core/network/api_exception.dart';

class ApiClient {
  ApiClient({Dio? dio}) : _dio = dio ?? _createDio();

  final Dio _dio;

  Dio get dio => _dio;

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: const Duration(milliseconds: ApiConfig.connectTimeoutMs),
        receiveTimeout: const Duration(milliseconds: ApiConfig.receiveTimeoutMs),
        headers: {'Accept': 'application/json'},
      ),
    );

    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    );

    return dio;
  }

  Future<Map<String, dynamic>> getJson(String path, {Map<String, dynamic>? query}) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(path, queryParameters: query);
      return _parseEnvelope(response.data);
    } on DioException catch (error) {
      throw _mapDioError(error);
    }
  }

  Future<Map<String, dynamic>> postMultipart(
    String path, {
    required FormData formData,
    void Function(int, int)? onSendProgress,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        path,
        data: formData,
        onSendProgress: onSendProgress,
      );
      return _parseEnvelope(response.data);
    } on DioException catch (error) {
      throw _mapDioError(error);
    }
  }

  Future<void> delete(String path) async {
    try {
      final response = await _dio.delete<Map<String, dynamic>>(path);
      _parseEnvelope(response.data);
    } on DioException catch (error) {
      throw _mapDioError(error);
    }
  }

  Future<List<int>> downloadBytes(
    String path, {
    void Function(int received, int total)? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.get<List<int>>(
        path,
        options: Options(responseType: ResponseType.bytes),
        onReceiveProgress: onReceiveProgress,
      );
      return response.data ?? [];
    } on DioException catch (error) {
      throw _mapDioError(error);
    }
  }

  Map<String, dynamic> _parseEnvelope(Map<String, dynamic>? body) {
    if (body == null) {
      throw ApiException(code: 'INTERNAL_SERVER_ERROR', message: 'Empty response from server.');
    }

    final success = body['success'] == true;
    if (success) return body;

    final error = body['error'] as Map<String, dynamic>? ?? {};
    final detailsJson = error['details'] as List<dynamic>? ?? [];
    throw ApiException(
      code: error['code'] as String? ?? 'INTERNAL_SERVER_ERROR',
      message: error['message'] as String? ?? 'Request failed.',
      details: detailsJson
          .map((item) => FieldError.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  ApiException _mapDioError(DioException error) {
    final responseData = error.response?.data;
    if (responseData is Map<String, dynamic> && responseData['success'] == false) {
      try {
        _parseEnvelope(responseData);
      } on ApiException catch (apiError) {
        return apiError;
      }
    }

    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      return ApiException(
        code: 'TIMEOUT',
        message: 'Request timed out. Please try again.',
        statusCode: error.response?.statusCode,
      );
    }

    if (error.type == DioExceptionType.connectionError) {
      return ApiException(
        code: 'NETWORK_ERROR',
        message: 'Unable to reach the server. Make sure the backend is running.',
        statusCode: error.response?.statusCode,
      );
    }

    final statusCode = error.response?.statusCode;
    if (statusCode == 502 || statusCode == 503 || statusCode == 504) {
      return ApiException(
        code: 'SERVER_UNAVAILABLE',
        message: 'The server is temporarily unavailable. Please try again shortly.',
        statusCode: statusCode,
      );
    }

    return ApiException(
      code: 'INTERNAL_SERVER_ERROR',
      message: 'Something went wrong. Please try again.',
      statusCode: statusCode,
    );
  }
}
