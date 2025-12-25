import 'package:pokedex/features/pokemons/data/models/pokemon.dart';
import 'package:result_dart/result_dart.dart';

abstract class PokemonRepositoryInterface {
  Future<Result<List<Pokemon>>> getPokemons();
}