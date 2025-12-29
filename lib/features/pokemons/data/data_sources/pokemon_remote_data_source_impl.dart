import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:pokedex/core/network/client_interface.dart';
import 'package:pokedex/features/pokemons/data/data_sources/pokemon_remote_data_source.dart';
import 'package:pokedex/features/pokemons/data/models/pokemon.dart';
import 'package:result_dart/result_dart.dart';

class PokemonRemoteDataSourceImpl implements PokemonRemoteDataSource {
  final ClientInterface client;

  PokemonRemoteDataSourceImpl({required this.client});

  @override
  Future<Result<List<Pokemon>>> getPokemons() async {
    try {
      Response response = await client.get("/master/pokedex.json");
      List data = jsonDecode(response.data['pokemon']);

      final list = data.map((pokemon) => Pokemon.fromJson(pokemon)).toList();
      return Success(list);
    } catch (e) {
      return Failure(Exception(e));
    }
  }
}
