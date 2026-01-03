import 'dart:convert';
import 'package:pokedex/core/storage/local_storage.dart';
import 'package:pokedex/features/pokemons/data/data_sources/interfaces/pokemon_local_data_source.dart';
import 'package:pokedex/features/pokemons/data/models/pokemon.dart';
import 'package:result_dart/result_dart.dart';

class PokemonLocalDataSourceImpl implements PokemonLocalDataSource {
  final LocalStorage prefs;

  PokemonLocalDataSourceImpl({required this.prefs});

  static const String _cacheKey = 'POKEMONS_CACHE';

  @override
  Future<Result<Unit>> cachePokemons(List<Pokemon> pokemons) async {
    try {
      final jsonString = jsonEncode(pokemons.map((p) => p.toJson()).toList());
      await prefs.setString(_cacheKey, jsonString);
      return Success(unit);
    } catch (e) {
      return Failure(Exception(e));
    }
  }

  @override
  Future<Result<List<Pokemon>>> getCachedPokemons() async {
    try {
      final jsonString = await prefs.getString(_cacheKey);
      if (jsonString == null) {
        return Failure(Exception("Não há nada em cache"));
      }

      final List decoded = jsonDecode(jsonString) as List;
      List<Pokemon> list =
          decoded
              .map((e) => Pokemon.fromJson(e as Map<String, dynamic>))
              .toList();
      return Success(list);
    } catch (e) {
      return Failure(Exception(e));
    }
  }

  @override
  Future<bool> hasCache() async => prefs.containsKey(_cacheKey);
}
