abstract class AppException implements Exception {
  final String message;

  AppException(this.message);

  @override
  String toString() => '$runtimeType: $message';
}

class NetworkException extends AppException {
  NetworkException(super.message);
}

class ApiException extends AppException {
  final int? statusCode;

  ApiException({required String message, this.statusCode}) : super(message);
}

class CacheException extends AppException {
  CacheException(super.message);
}

class UnexpectedException extends AppException {
  UnexpectedException(super.message);
}
