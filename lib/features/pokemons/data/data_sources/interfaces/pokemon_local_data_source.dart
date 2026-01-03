import 'package:pokedex/features/pokemons/data/models/pokemon.dart';
import 'package:result_dart/result_dart.dart';

abstract class PokemonLocalDataSource {
  Future<Result<Unit>> cachePokemons(List<Pokemon> pokemons);

  Future<Result<List<Pokemon>>> getCachedPokemons();

  Future<bool> hasCache();
}
