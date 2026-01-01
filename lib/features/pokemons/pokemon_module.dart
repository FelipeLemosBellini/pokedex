import 'package:flutter_modular/flutter_modular.dart';
import 'package:pokedex/app_module.dart';
import 'package:pokedex/core/connectivity/network_info.dart';
import 'package:pokedex/core/network/client.dart';
import 'package:pokedex/core/storage/local_storage.dart';
import 'package:pokedex/features/pokemons/data/data_sources/pokemon_local_data_source.dart';
import 'package:pokedex/features/pokemons/data/data_sources/pokemon_local_data_source_impl.dart';
import 'package:pokedex/features/pokemons/data/data_sources/pokemon_remote_data_source.dart';
import 'package:pokedex/features/pokemons/data/data_sources/pokemon_remote_data_source_impl.dart';
import 'package:pokedex/features/pokemons/data/repositories_impl/pokemon_repository_impl.dart';
import 'package:pokedex/features/pokemons/domain/repositories/pokemon_repository_interface.dart';
import 'package:pokedex/features/pokemons/presentation/bloc/pokemon_bloc.dart';
import 'package:pokedex/features/pokemons/presentation/page/pokemon_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PokemonModule extends Module {
  @override
  List<Module> get imports => [
    AppModule(sharedPreferences: Modular.get<SharedPreferences>()),
  ];

  @override
  void binds(i) {
    i.addSingleton<PokemonRemoteDataSource>(
      () => PokemonRemoteDataSourceImpl(client: i.get<HttpClient>()),
    );
    i.addSingleton<PokemonLocalDataSource>(
      () => PokemonLocalDataSourceImpl(prefs: i.get<LocalStorage>()),
    );

    i.addLazySingleton<PokemonRepositoryInterface>(
      () => PokemonRepositoryImpl(
        pokemonRemoteDataSource: i.get<PokemonRemoteDataSource>(),
        pokemonLocalDataSource: i.get<PokemonLocalDataSource>(),
        networkInfo: i.get<NetworkInfo>(),
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
