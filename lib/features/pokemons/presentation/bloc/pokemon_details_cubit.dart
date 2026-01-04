import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/features/pokemons/domain/models/enum/type_of_pokemon.dart';
import 'package:pokedex/features/pokemons/domain/models/pokemon.dart';
import 'package:pokedex/features/pokemons/domain/repositories/pokemon_repository_interface.dart';

class PokemonDetailsState {
  final List<Pokemon> related;

  PokemonDetailsState({required this.related});
}

class PokemonDetailsMessage extends PokemonDetailsState {
  final String message;

  PokemonDetailsMessage(this.message, {required super.related});
}

class PokemonDetailsCubit extends Cubit<PokemonDetailsState> {
  final PokemonRepositoryInterface pokemonRepository;

  PokemonDetailsCubit({required this.pokemonRepository})
    : super(PokemonDetailsState(related: []));

  void getRelatedPokemons(List<TypeOfPokemon> typesOfPokemons) async {
    var response = await pokemonRepository.getRelated(
      listOfType: typesOfPokemons,
    );
    response.fold((relatedPokemons) {
      if (relatedPokemons.isEmpty) {
        emit(
          PokemonDetailsMessage(
            "Nenhum pokemon relacionado encontrado",
            related: relatedPokemons,
          ),
        );
      }
      emit(PokemonDetailsState(related: relatedPokemons));
    }, (error) {});
  }
}
