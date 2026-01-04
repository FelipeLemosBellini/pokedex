import 'package:mocktail/mocktail.dart';
import 'package:pokedex/features/pokemons/domain/repositories/pokemon_repository_interface.dart';

class MockPokemonRepository extends Mock
    implements PokemonRepositoryInterface {}
