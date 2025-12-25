import 'package:pokedex/features/pokemons/data/data_sources/pokemon_remote_data_source.dart';
import 'package:pokedex/features/pokemons/data/models/pokemon.dart';
import 'package:pokedex/features/pokemons/domain/repositories/pokemon_repository_interface.dart';
import 'package:result_dart/result_dart.dart';

class PokemonRepositoryImpl implements PokemonRepositoryInterface {
  final PokemonRemoteDataSource pokemonRemoteDataSource;

  PokemonRepositoryImpl({required this.pokemonRemoteDataSource});

  @override
  Future<Result<List<Pokemon>>> getPokemons() async {
    return await pokemonRemoteDataSource.getPokemons();
  }
}
