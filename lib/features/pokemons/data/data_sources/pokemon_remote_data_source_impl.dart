import 'package:pokedex/core/network/client.dart';
import 'package:pokedex/features/pokemons/data/data_sources/pokemon_remote_data_source.dart';
import 'package:pokedex/features/pokemons/data/models/pokemon.dart';
import 'package:result_dart/result_dart.dart';

class PokemonRemoteDataSourceImpl implements PokemonRemoteDataSource {
  final DioClient client;

  PokemonRemoteDataSourceImpl({required this.client});

  @override
  Future<Result<List<Pokemon>>> getPokemons() async {
    try {
      var response = await client.get("/master/pokedex.json");
      List<Pokemon> list =
          response.data.map((pokemon) => Pokemon.fromJson(pokemon)).toList();
      return Success(list);
    } catch (e) {
      return Failure(Exception(e));
    }
  }
}
