import 'package:pokedex/core/connectivity/network_info.dart';
import 'package:pokedex/features/pokemons/data/data_sources/interfaces/pokemon_local_data_source.dart';
import 'package:pokedex/features/pokemons/data/data_sources/interfaces/pokemon_remote_data_source.dart';
import 'package:pokedex/features/pokemons/data/models/enum/type_of_pokemon.dart';
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

  @override
  Future<Result<List<Pokemon>>> searchPokemons({required String value}) async {
    try {
      var response = pokemonLocalDataSource.getCachedPokemons();
      return await response.fold(
        (allPokemons) {
          final query = value.trim().toLowerCase();
          final int? idQuery = int.tryParse(query);

          List<Pokemon> filtered =
              allPokemons.where((pokemon) {
                final nameMatch = pokemon.name.toLowerCase().contains(query);

                final idMatch = idQuery != null && pokemon.id == idQuery;

                final numMatch =
                    pokemon.number == query ||
                    pokemon.number == query.padLeft(3, '0');

                return nameMatch || idMatch || numMatch;
              }).toList();

          return Success(filtered);
        },
        (onError) {
          return Failure(onError);
        },
      );
    } catch (e) {
      return Failure(Exception(e));
    }
  }

  @override
  Future<Result<List<Pokemon>>> getRelated({
    required List<TypeOfPokemon> listOfType,
  }) async {
    try {
      var response = await pokemonLocalDataSource.getCachedPokemons();
      return response.fold(
        (allPokemons) {
          final related =
              allPokemons
                  .where(
                    (pokemon) =>
                        pokemon.type.any((t) => listOfType.contains(t)),
                  )
                  .toList();

          // ordena pelos mais parecidos (mais tipos em comum primeiro)
          related.sort((a, b) {
            final aMatches = a.type.where((t) => listOfType.contains(t)).length;
            final bMatches = b.type.where((t) => listOfType.contains(t)).length;
            return bMatches.compareTo(aMatches);
          });

          return Success(related);
        },
        (error) {
          return Failure(error);
        },
      );
    } catch (e) {
      return Failure(Exception(e));
    }
  }
}
