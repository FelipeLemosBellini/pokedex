import 'package:pokedex/features/pokemons/data/models/enum/type_of_pokemon.dart';
import 'package:pokedex/features/pokemons/data/models/pokemon.dart';
import 'package:result_dart/result_dart.dart';

abstract class PokemonRepositoryInterface {
  Future<Result<List<Pokemon>>> getPokemons();

  Future<Result<List<Pokemon>>> searchPokemons({required String value});

  Future<Result<List<Pokemon>>> getRelated({
    required List<TypeOfPokemon> listOfType,
  });
}
