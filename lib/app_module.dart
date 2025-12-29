import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:pokedex/core/env/env.dart';
import 'package:pokedex/core/network/client_impl.dart';
import 'package:pokedex/core/network/client_interface.dart';
import 'package:pokedex/features/pokemons/pokemon_module.dart';

class AppModule extends Module {
  @override
  void binds(i) {
    i.addSingleton<Dio>(() => Dio());
    i.add<ClientInterface>(
      () => DioClient(dio: i.get<Dio>(), baseUrl: Env.pokedexBaseUrl),
    );
  }

  @override
  void routes(r) {
    r.module(Modular.initialRoute, module: PokemonModule());
  }
}
