import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class Env {
  //base url
  static String get pokedexBaseUrl => dotenv.env["PokemonGo-Pokedex"] ?? '';

  static Future<void> start() async {
    await dotenv.load(fileName: "./pokedex.env");
  }
}
