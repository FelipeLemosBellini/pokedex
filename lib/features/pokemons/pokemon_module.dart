import 'package:flutter_modular/flutter_modular.dart';
import 'package:pokedex/app_module.dart';
import 'package:pokedex/core/network/client_interface.dart';
import 'package:pokedex/features/pokemons/data/data_sources/pokemon_remote_data_source.dart';
import 'package:pokedex/features/pokemons/data/data_sources/pokemon_remote_data_source_impl.dart';
import 'package:pokedex/features/pokemons/data/repositories_impl/pokemon_repository_impl.dart';
import 'package:pokedex/features/pokemons/domain/repositories/pokemon_repository_interface.dart';
import 'package:pokedex/features/pokemons/presentation/bloc/pokemon_bloc.dart';
import 'package:pokedex/features/pokemons/presentation/page/pokemon_page.dart';

class PokemonModule extends Module {
  @override
  List<Module> get imports => [AppModule()];

  @override
  void binds(i) {
    i.addSingleton<PokemonRemoteDataSource>(
      () => PokemonRemoteDataSourceImpl(client: i.get<ClientInterface>()),
    );

    i.addLazySingleton<PokemonRepositoryInterface>(
      () => PokemonRepositoryImpl(
        pokemonRemoteDataSource: i.get<PokemonRemoteDataSource>(),
      ),
    );

    i.addLazySingleton<PokemonBloc>(
      () => PokemonBloc(pokemonRepository: i<PokemonRepositoryInterface>()),
    );
  }

  @override
  void routes(r) {
    r.child('/', child: (_) => const PokemonPage());
  }
}
