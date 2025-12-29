import 'package:dio/dio.dart';
import 'package:pokedex/core/env/env.dart';

abstract class ClientInterface {
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters});
}
