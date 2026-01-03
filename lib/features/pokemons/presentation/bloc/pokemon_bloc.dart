import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/features/pokemons/data/models/enum/type_of_pokemon.dart';
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

class FilterByTypeEvent extends PokemonEvent {
  final TypeOfPokemon? type;

  FilterByTypeEvent({this.type});
}

class ClearFiltersEvent extends PokemonEvent {}

class ToggleFilterEvent extends PokemonEvent {}

class PokemonState {
  final bool isAlphabetical;
  final bool isAscending;
  final TypeOfPokemon? selectedType;
  final bool showExpandedFilter;

  PokemonState({
    this.isAlphabetical = false,
    this.isAscending = true,
    this.selectedType,
    this.showExpandedFilter = false,
  });
}

class PokemonInitialState extends PokemonState {
  PokemonInitialState({
    super.isAlphabetical,
    super.isAscending,
    super.selectedType,
    super.showExpandedFilter,
  });
}

class PokemonLoading extends PokemonState {
  PokemonLoading({
    super.isAlphabetical,
    super.isAscending,
    super.selectedType,
    super.showExpandedFilter,
  });
}

class PokemonError extends PokemonState {
  final String message;

  PokemonError({
    required this.message,
    super.isAlphabetical,
    super.isAscending,
    super.selectedType,
    super.showExpandedFilter,
  });
}

class PokemonLoaded extends PokemonState {
  final List<Pokemon> pokemons;

  PokemonLoaded({
    required this.pokemons,
    super.isAlphabetical,
    super.isAscending,
    super.selectedType,
    super.showExpandedFilter,
  });
}

class PokemonSearched extends PokemonState {
  final List<Pokemon> pokemons;

  PokemonSearched({
    required this.pokemons,
    super.isAlphabetical,
    super.isAscending,
    super.selectedType,
    super.showExpandedFilter,
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
    on<FilterByTypeEvent>(_onFilterByTypeEvent);
    on<ClearFiltersEvent>(_onClearFiltersEvent);
    on<ToggleFilterEvent>(_onToggleFilterEvent);
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
        _allPokemons = filtered;
        emit(
          PokemonLoaded(
            pokemons: filtered,
            showExpandedFilter: state.showExpandedFilter,
          ),
        );
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
        emit(
          PokemonLoaded(
            pokemons: success,
            showExpandedFilter: state.showExpandedFilter,
          ),
        );
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
        showExpandedFilter: state.showExpandedFilter,
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
        showExpandedFilter: state.showExpandedFilter,
      ),
    );
  }

  void _onFilterByTypeEvent(
    FilterByTypeEvent event,
    Emitter<PokemonState> emit,
  ) {
    final type = event.type;

    final filtered = _applyFilters(
      _allPokemons,
      alphabeticalActive: state.isAlphabetical,
      numericActive: state.isAscending,
      typeFilter: type,
    );

    emit(
      PokemonLoaded(
        pokemons: filtered,
        isAlphabetical: state.isAlphabetical,
        isAscending: state.isAscending,
        selectedType: type,
        showExpandedFilter: state.showExpandedFilter,
      ),
    );
  }

  void _onClearFiltersEvent(
    ClearFiltersEvent event,
    Emitter<PokemonState> emit,
  ) {
    final filtered = _applyFilters(
      _allPokemons,
      alphabeticalActive: false,
      numericActive: false,
      typeFilter: null,
    );

    emit(
      PokemonLoaded(
        pokemons: filtered,
        isAlphabetical: false,
        isAscending: false,
        selectedType: null,

        showExpandedFilter: state.showExpandedFilter,
      ),
    );
  }

  void _onToggleFilterEvent(
    ToggleFilterEvent event,
    Emitter<PokemonState> emit,
  ) {
    final filtered = _applyFilters(
      _allPokemons,
      alphabeticalActive: state.isAlphabetical,
      numericActive: state.isAscending,
      typeFilter: state.selectedType,
    );
    emit(
      PokemonLoaded(
        pokemons: filtered,
        isAlphabetical: state.isAlphabetical,
        isAscending: state.isAscending,
        selectedType: null,
        showExpandedFilter: !state.showExpandedFilter,
      ),
    );
  }

  List<Pokemon> _applyFilters(
    List<Pokemon> list, {
    bool? alphabeticalActive,
    bool? numericActive,
    TypeOfPokemon? typeFilter,
  }) {
    final useAlphabetical = alphabeticalActive ?? state.isAlphabetical;
    final useNumeric = numericActive ?? state.isAscending;
    final selectedType = typeFilter ?? state.selectedType;

    List<Pokemon> sorted = list;
    if (selectedType != null) {
      sorted = sorted.where((p) => p.type.contains(selectedType)).toList();
    }
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
