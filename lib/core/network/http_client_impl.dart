import 'package:dio/dio.dart';
import 'package:pokedex/core/env/env.dart';
import 'package:pokedex/core/network/client.dart';

class HttpClientImpl implements HttpClient {
  final Dio dio;
  final String baseUrl;

  HttpClientImpl({required this.dio, required this.baseUrl}) {
    dio
      ..options.baseUrl = baseUrl
      ..options.connectTimeout = const Duration(seconds: 60)
      ..options.receiveTimeout = const Duration(seconds: 60);
  }

  @override
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return await dio.get(path, queryParameters: queryParameters);
  }
}
