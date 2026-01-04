import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:pokedex/core/exception/app_exception.dart';
import 'package:pokedex/core/network/client.dart';
import 'package:pokedex/features/pokemons/data/data_sources/interfaces/pokemon_remote_data_source.dart';
import 'package:pokedex/features/pokemons/domain/models/pokemon.dart';
import 'package:result_dart/result_dart.dart';

class PokemonRemoteDataSourceImpl implements PokemonRemoteDataSource {
  final HttpClient client;

  PokemonRemoteDataSourceImpl({required this.client});

  @override
  Future<ResultDart<List<Pokemon>, AppException>> getPokemons() async {
    try {
      Response response = await client.get("/master/pokedex.json");
      Map<String, dynamic> data = jsonDecode(response.data);
      List<dynamic> list = data['pokemon'];
      final pokemon = list.map((pokemon) => Pokemon.fromJson(pokemon)).toList();
      return Success(pokemon);
    } on DioException catch (e) {
      return Failure(
        ApiException(
          statusCode: e.response?.statusCode,
          message: e.message ?? "",
        ),
      );
    } catch (e) {
      return Failure(UnexpectedException(e.toString()));
    }
  }
}
