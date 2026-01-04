import 'package:pokedex/core/exception/app_exception.dart';
import 'package:pokedex/features/pokemons/domain/models/pokemon.dart';
import 'package:result_dart/result_dart.dart';

abstract class PokemonLocalDataSource {
  Future<ResultDart<Unit, AppException>> cachePokemons(List<Pokemon> pokemons);

  Future<ResultDart<List<Pokemon>, AppException>> getCachedPokemons();

  Future<ResultDart<bool, AppException>> hasCache();
}
