import 'package:pokedex/core/exception/app_exception.dart';
import 'package:pokedex/features/pokemons/domain/models/enum/type_of_pokemon.dart';
import 'package:pokedex/features/pokemons/domain/models/pokemon.dart';
import 'package:result_dart/result_dart.dart';

abstract class PokemonRepositoryInterface {
  Future<ResultDart<List<Pokemon>, AppException>> getPokemons({
    bool refresh = false,
  });

  Future<ResultDart<List<Pokemon>, AppException>> searchPokemons({
    required String value,
  });

  Future<ResultDart<List<Pokemon>, AppException>> getRelated({
    required List<TypeOfPokemon> listOfType,
  });
}
