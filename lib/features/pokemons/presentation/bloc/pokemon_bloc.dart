import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/features/pokemons/data/models/pokemon.dart';
import 'package:pokedex/features/pokemons/domain/repositories/pokemon_repository_interface.dart';

class PokemonEvent {}

class LoadPokemonsEvent extends PokemonEvent {}

class SearchPokemonsEvent extends PokemonEvent {
  final String value;

  SearchPokemonsEvent({required this.value});
}

class ErrorEvent extends PokemonEvent {}

class ToggleAlphabeticalFilterEvent extends PokemonEvent {}

class ToggleNumericFilterEvent extends PokemonEvent {}

class PokemonState {
  final bool isAlphabetical;
  final bool isAscending;

  PokemonState({this.isAlphabetical = false, this.isAscending = true});
}

class PokemonInitialState extends PokemonState {
  PokemonInitialState({super.isAlphabetical, super.isAscending});
}

class PokemonLoading extends PokemonState {
  PokemonLoading({super.isAlphabetical, super.isAscending});
}

class PokemonError extends PokemonState {
  final String message;

  PokemonError({
    required this.message,
    super.isAlphabetical,
    super.isAscending,
  });
}

class PokemonLoaded extends PokemonState {
  final List<Pokemon> pokemons;

  PokemonLoaded({
    required this.pokemons,
    super.isAlphabetical,
    super.isAscending,
  });
}

class PokemonSearched extends PokemonState {
  final List<Pokemon> pokemons;

  PokemonSearched({
    required this.pokemons,
    super.isAlphabetical,
    super.isAscending,
  });
}

class PokemonBloc extends Bloc<PokemonEvent, PokemonState> {
  final PokemonRepositoryInterface pokemonRepository;

  List<Pokemon> _allPokemons = [];

  PokemonBloc({required this.pokemonRepository})
    : super(PokemonInitialState()) {
    on<LoadPokemonsEvent>(_onLoadPokemonsEvent);
    on<SearchPokemonsEvent>(_onSearchPokemonsEvent);
    on<ToggleAlphabeticalFilterEvent>(_onToggleAlphabeticalFilterEvent);
    on<ToggleNumericFilterEvent>(_onToggleNumericFilterEvent);
  }

  void _onLoadPokemonsEvent(event, emit) async {
    emit(PokemonLoading());
    await Future.delayed(Duration(milliseconds: 1000));
    var response = await pokemonRepository.getPokemons();
    response.fold(
      (success) {
        final filtered = _applyFilters(
          success,
          alphabeticalActive: false,
          numericActive: true,
        );
        emit(PokemonLoaded(pokemons: filtered));
      },
      (error) {
        emit(PokemonError(message: error.toString()));
      },
    );
  }

  void _onSearchPokemonsEvent(SearchPokemonsEvent event, emit) async {
    var response = await pokemonRepository.searchPokemons(value: event.value);
    response.fold(
      (success) {
        emit(PokemonLoaded(pokemons: success));
      },
      (error) {
        emit(PokemonError(message: error.toString()));
      },
    );
  }

  void _onToggleAlphabeticalFilterEvent(
    ToggleAlphabeticalFilterEvent event,
    Emitter<PokemonState> emit,
  ) {
    final newAlphabeticalActive = !state.isAlphabetical;

    // se ligar o alfabético, desliga o numérico (opcional)
    final newNumericActive = newAlphabeticalActive ? false : state.isAscending;

    List<Pokemon> baseList;
    if (state is PokemonLoaded) {
      baseList = (state as PokemonLoaded).pokemons;
    } else {
      baseList = _allPokemons;
    }

    final filtered = _applyFilters(
      baseList,
      alphabeticalActive: newAlphabeticalActive,
      numericActive: newNumericActive,
    );

    emit(
      PokemonLoaded(
        pokemons: filtered,
        isAlphabetical: newAlphabeticalActive,
        isAscending: newNumericActive,
      ),
    );
  }

  void _onToggleNumericFilterEvent(
    ToggleNumericFilterEvent event,
    Emitter<PokemonState> emit,
  ) {
    final newNumericActive = !state.isAscending;

    // se ligar o numérico, desliga o alfabético (opcional)
    final newAlphabeticalActive =
        newNumericActive ? false : state.isAlphabetical;

    List<Pokemon> baseList;
    if (state is PokemonLoaded) {
      baseList = (state as PokemonLoaded).pokemons;
    } else {
      baseList = _allPokemons;
    }

    final filtered = _applyFilters(
      baseList,
      alphabeticalActive: newAlphabeticalActive,
      numericActive: newNumericActive,
    );

    emit(
      PokemonLoaded(
        pokemons: filtered,
        isAlphabetical: newAlphabeticalActive,
        isAscending: newNumericActive,
      ),
    );
  }

  List<Pokemon> _applyFilters(
    List<Pokemon> list, {
    bool? alphabeticalActive,
    bool? numericActive,
  }) {
    final useAlphabetical = alphabeticalActive ?? state.isAlphabetical;
    final useNumeric = numericActive ?? state.isAscending;

    List<Pokemon> sorted = list;
    if (useAlphabetical) {
      sorted.sort(
        (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      );
    } else if (useNumeric) {
      sorted.sort((a, b) => a.id.compareTo(b.id));
    }

    return sorted;
  }
}
