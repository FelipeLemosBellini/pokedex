import 'package:dio/dio.dart';
import 'package:pokedex/core/network/client.dart';
import 'package:pokedex/core/network/interceptors/retry_interceptor.dart';

class HttpClientImpl implements HttpClient {
  final Dio dio;
  final String baseUrl;

  HttpClientImpl({required this.dio, required this.baseUrl}) {
    dio
      ..options.baseUrl = baseUrl
      ..options.connectTimeout = const Duration(seconds: 60)
      ..options.receiveTimeout = const Duration(seconds: 60);
    dio.interceptors.add(RetryInterceptor(dio: dio));
  }

  @override
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return await dio.get(path, queryParameters: queryParameters);
  }
}
