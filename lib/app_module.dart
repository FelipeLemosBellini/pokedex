import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:pokedex/core/network/client.dart';
import 'package:pokedex/features/pokemons/pokemon_module.dart';

class AppModule extends Module {
  @override
  void binds(i) {
    i.addSingleton<Dio>(() => Dio());
    i.addSingleton<DioClient>(() => DioClient(i()));
  }

  @override
  void routes(r) {
    r.module('/pokemon', module: PokemonModule());
  }
}