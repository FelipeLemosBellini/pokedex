import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/features/pokemons/data/models/pokemon.dart';
import 'package:pokedex/features/pokemons/domain/repositories/pokemon_repository_interface.dart';

class PokemonEvent {}

class LoadPokemonsEvent extends PokemonEvent {}

class ErrorEvent extends PokemonEvent {}

class PokemonState {
  PokemonState();
}

class PokemonInitialState extends PokemonState {
  PokemonInitialState();
}

class PokemonLoading extends PokemonState {
  PokemonLoading();
}

class PokemonError extends PokemonState {
  final String message;

  PokemonError({required this.message});
}

class PokemonLoaded extends PokemonState {
  final List<Pokemon> pokemons;

  PokemonLoaded({required this.pokemons});
}

class PokemonBloc extends Bloc<PokemonEvent, PokemonState> {
  final PokemonRepositoryInterface pokemonRepository;

  PokemonBloc({required this.pokemonRepository})
    : super(PokemonInitialState()) {
    on<LoadPokemonsEvent>(_onLoadPokemonsEvent);
  }

  void _onLoadPokemonsEvent(event, emit) async {
    var response = await pokemonRepository.getPokemons();
    response.fold(
      (success) {
        emit(PokemonLoaded(pokemons: success));
      },
      (error) {
        emit(PokemonError(message: error.toString()));
      },
    );
  }
}
