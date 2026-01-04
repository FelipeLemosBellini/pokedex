import 'dart:async';
import 'package:dio/dio.dart';

class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int maxRetries;

  RetryInterceptor({required this.dio, this.maxRetries = 2});

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final requestOptions = err.requestOptions;

    int attempt = (requestOptions.extra['retry_attempt'] as int?) ?? 0;

    if (_shouldRetry(err) && attempt < maxRetries) {
      attempt++;
      requestOptions.extra['retry_attempt'] = attempt;

      try {
        final response = await dio.fetch(requestOptions);
        return handler.resolve(response);
      } catch (e) {
        return handler.next(e as DioException);
      }
    }

    return handler.next(err);
  }

  bool _shouldRetry(DioException err) {
    if (err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout) {
      return true;
    }

    final statusCode = err.response?.statusCode ?? 0;
    if ([500, 502, 503, 504].contains(statusCode)) {
      return true;
    }

    return false;
  }
}
