import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:pokedex/core/network/client.dart';
import 'package:pokedex/features/pokemons/data/data_sources/interfaces/pokemon_remote_data_source.dart';
import 'package:pokedex/features/pokemons/data/models/pokemon.dart';
import 'package:result_dart/result_dart.dart';

class PokemonRemoteDataSourceImpl implements PokemonRemoteDataSource {
  final HttpClient client;

  PokemonRemoteDataSourceImpl({required this.client});

  @override
  Future<Result<List<Pokemon>>> getPokemons() async {
    try {
      Response response = await client.get("/master/pokedex.json");
      Map<String, dynamic> data = jsonDecode(response.data);
      List<dynamic> list = data['pokemon'];
      final pokemon = list.map((pokemon) => Pokemon.fromJson(pokemon)).toList();
      return Success(pokemon);
    } catch (e) {
      return Failure(Exception(e));
    }
  }
}
