import 'package:pokedex/core/connectivity/network_info.dart';
import 'package:pokedex/features/pokemons/data/data_sources/pokemon_local_data_source.dart';
import 'package:pokedex/features/pokemons/data/data_sources/pokemon_remote_data_source.dart';
import 'package:pokedex/features/pokemons/data/models/pokemon.dart';
import 'package:pokedex/features/pokemons/domain/repositories/pokemon_repository_interface.dart';
import 'package:result_dart/result_dart.dart';

class PokemonRepositoryImpl implements PokemonRepositoryInterface {
  final PokemonRemoteDataSource pokemonRemoteDataSource;
  final PokemonLocalDataSource pokemonLocalDataSource;
  final NetworkInfo networkInfo;

  PokemonRepositoryImpl({
    required this.pokemonRemoteDataSource,
    required this.pokemonLocalDataSource,
    required this.networkInfo,
  });

  @override
  Future<Result<List<Pokemon>>> getPokemons({bool refresh = false}) async {
    try {
      bool hasNotCache = !(await pokemonLocalDataSource.hasCache());
      bool hasConnection = await networkInfo.isConnected;

      if (hasConnection && (refresh || hasNotCache)) {
        var response = await pokemonRemoteDataSource.getPokemons();
        return response.fold(
          (success) async {
            await pokemonLocalDataSource.cachePokemons(success);
            return response;
          },
          (error) {
            return Failure(error);
          },
        );
      }
      return await pokemonLocalDataSource.getCachedPokemons();
    } catch (e) {
      return Failure(Exception(e));
    }
  }
}
