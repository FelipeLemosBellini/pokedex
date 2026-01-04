import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:pokedex/core/exception/app_exception.dart';
import 'package:pokedex/core/storage/local_storage.dart';
import 'package:pokedex/features/pokemons/data/data_sources/interfaces/pokemon_local_data_source.dart';
import 'package:pokedex/features/pokemons/domain/models/pokemon.dart';
import 'package:result_dart/result_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PokemonLocalDataSourceImpl implements PokemonLocalDataSource {
  final LocalStorage prefs;

  PokemonLocalDataSourceImpl({required this.prefs});

  static const String _cacheKey = 'POKEMONS_CACHE';

  @override
  Future<ResultDart<Unit, AppException>> cachePokemons(
    List<Pokemon> pokemons,
  ) async {
    try {
      final jsonString = jsonEncode(pokemons.map((p) => p.toJson()).toList());
      await prefs.setString(_cacheKey, jsonString);
      return Success(unit);
    } catch (e) {
      return Failure(CacheException(e.toString()));
    }
  }

  @override
  Future<ResultDart<List<Pokemon>, AppException>> getCachedPokemons() async {
    try {
      final jsonString = await prefs.getString(_cacheKey);
      if (jsonString == null) {
        return Failure(CacheException("cache not found"));
      }

      final List decoded = jsonDecode(jsonString) as List;
      List<Pokemon> list =
          decoded
              .map((e) => Pokemon.fromJson(e as Map<String, dynamic>))
              .toList();
      return Success(list);
    } catch (e) {
      return Failure(CacheException(e.toString()));
    }
  }

  @override
  Future<ResultDart<bool, AppException>> hasCache() async {
    try {
      bool hasCache = await prefs.containsKey(_cacheKey);
      return Success(hasCache);
    } catch (e) {
      return Failure(CacheException(e.toString()));
    }
  }
}
