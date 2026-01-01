import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:pokedex/core/connectivity/network_info.dart';
import 'package:pokedex/core/connectivity/network_info_impl.dart';
import 'package:pokedex/core/env/env.dart';
import 'package:pokedex/core/network/client.dart';
import 'package:pokedex/core/network/http_client_impl.dart';
import 'package:pokedex/core/storage/local_storage.dart';
import 'package:pokedex/core/storage/local_storage_impl.dart';
import 'package:pokedex/features/pokemons/pokemon_module.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppModule extends Module {
  final SharedPreferences sharedPreferences;

  AppModule({required this.sharedPreferences});

  @override
  void binds(i) {
    i.addSingleton<Dio>(() => Dio());
    i.add<HttpClient>(
      () => HttpClientImpl(dio: i.get<Dio>(), baseUrl: Env.pokedexBaseUrl),
    );

    i.addInstance<SharedPreferences>(sharedPreferences);

    i.addSingleton<LocalStorage>(
      () => LocalStorageImpl(sharedPreferences: i.get<SharedPreferences>()),
    );

    i.addSingleton<Connectivity>(() => Connectivity());
    i.addSingleton<NetworkInfo>(
      () => NetworkInfoImpl(connectivity: i.get<Connectivity>()),
    );
  }

  @override
  void routes(r) {
    r.module(Modular.initialRoute, module: PokemonModule());
  }
}
