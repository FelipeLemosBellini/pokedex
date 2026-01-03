import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';

import 'package:pokedex/features/pokemons/domain/repositories/pokemon_repository_interface.dart';
import 'package:pokedex/features/pokemons/presentation/bloc/pokemon_bloc.dart';

import 'fixtures/fixture_list_pokemons.dart';

class MockPokemonRepository extends Mock
    implements PokemonRepositoryInterface {}

void main() {
  late MockPokemonRepository mockPokemonRepository;
  late PokemonBloc pokemonBloc;

  setUp(() {
    mockPokemonRepository = MockPokemonRepository();
    pokemonBloc = PokemonBloc(pokemonRepository: mockPokemonRepository);
  });

  tearDown(() {
    pokemonBloc.close();
  });

  group('PokemonBloc', () {
    test('estado inicial deve ser PokemonInitialState', () {
      expect(pokemonBloc.state, isA<PokemonInitialState>());
      expect(pokemonBloc.state.isAlphabetical, false);
      expect(pokemonBloc.state.isAscending, true);
      expect(pokemonBloc.state.selectedType, isNull);
      expect(pokemonBloc.state.showExpandedFilter, false);
    });

    blocTest<PokemonBloc, PokemonState>(
      'LoadPokemonsEvent - sucesso: emite [PokemonLoading, PokemonLoaded] com lista ordenada por id',
      build: () {
        when(
          () => mockPokemonRepository.getPokemons(),
        ).thenAnswer((_) async => Success(allPokemons));
        return pokemonBloc;
      },
      act: (bloc) => bloc.add(LoadPokemonsEvent()),
      // há um delay de 1 segundo dentro do bloc
      wait: const Duration(milliseconds: 1200),
      expect:
          () => [
            isA<PokemonLoading>(),
            isA<PokemonLoaded>()
                .having((s) => s.pokemons.length, 'length', 3)
                // numericActive = true no load => ordena por id (1,4,7)
                .having(
                  (s) => s.pokemons.map((p) => p.id).toList(),
                  'ordenado por id',
                  [1, 4, 7],
                )
                .having((s) => s.isAlphabetical, 'isAlphabetical', false)
                .having((s) => s.isAscending, 'isAscending', true)
                .having((s) => s.selectedType, 'selectedType', isNull)
                .having(
                  (s) => s.showExpandedFilter,
                  'showExpandedFilter',
                  false,
                ),
          ],
      verify: (_) {
        verify(() => mockPokemonRepository.getPokemons()).called(1);
      },
    );

    blocTest<PokemonBloc, PokemonState>(
      'LoadPokemonsEvent - erro: emite [PokemonLoading, PokemonError]',
      build: () {
        when(
          () => mockPokemonRepository.getPokemons(),
        ).thenAnswer((_) async => Failure(Exception('erro ao buscar')));
        return pokemonBloc;
      },
      act: (bloc) => bloc.add(LoadPokemonsEvent()),
      wait: const Duration(milliseconds: 1200),
      expect:
          () => [
            isA<PokemonLoading>(),
            isA<PokemonError>().having(
              (s) => s.message,
              'message',
              contains('erro ao buscar'),
            ),
          ],
      verify: (_) {
        verify(() => mockPokemonRepository.getPokemons()).called(1);
      },
    );

    blocTest<PokemonBloc, PokemonState>(
      'SearchPokemonsEvent - sucesso: emite PokemonLoaded com lista retornada pelo search',
      build: () {
        when(
          () =>
              mockPokemonRepository.searchPokemons(value: any(named: 'value')),
        ).thenAnswer((_) async => Success([bulbasaur]));
        return pokemonBloc;
      },
      act: (bloc) => bloc.add(SearchPokemonsEvent(value: 'bulba')),
      expect:
          () => [
            isA<PokemonLoaded>()
                .having((s) => s.pokemons.length, 'length', 1)
                .having((s) => s.pokemons.first.name, 'name', 'Bulbasaur')
                .having(
                  (s) => s.showExpandedFilter,
                  'showExpandedFilter',
                  false,
                ),
          ],
      verify: (_) {
        verify(
          () => mockPokemonRepository.searchPokemons(value: 'bulba'),
        ).called(1);
      },
    );

    blocTest<PokemonBloc, PokemonState>(
      'SearchPokemonsEvent - erro: emite PokemonError',
      build: () {
        when(
          () =>
              mockPokemonRepository.searchPokemons(value: any(named: 'value')),
        ).thenAnswer((_) async => Failure(Exception('erro na busca')));
        return pokemonBloc;
      },
      act: (bloc) => bloc.add(SearchPokemonsEvent(value: 'char')),
      expect:
          () => [
            isA<PokemonError>().having(
              (s) => s.message,
              'message',
              contains('erro na busca'),
            ),
          ],
      verify: (_) {
        verify(
          () => mockPokemonRepository.searchPokemons(value: 'char'),
        ).called(1);
      },
    );

    blocTest<PokemonBloc, PokemonState>(
      'ToggleAlphabeticalFilterEvent - deve alternar para ordenação alfabética',
      build: () {
        when(
          () => mockPokemonRepository.getPokemons(),
        ).thenAnswer((_) async => Success(allPokemons));
        return pokemonBloc;
      },
      act: (bloc) async {
        // carrega pokemons primeiro
        bloc.add(LoadPokemonsEvent());
        await Future.delayed(const Duration(milliseconds: 1100));
        // depois aciona o filtro alfabético
        bloc.add(ToggleAlphabeticalFilterEvent());
      },
      wait: const Duration(milliseconds: 1300),
      expect:
          () => [
            isA<PokemonLoading>(),
            // estado após LoadPokemonsEvent (ordenado por id)
            isA<PokemonLoaded>()
                .having(
                  (s) => s.pokemons.map((p) => p.id).toList(),
                  'ordenado por id',
                  [1, 4, 7],
                )
                .having((s) => s.isAlphabetical, 'isAlphabetical', false)
                .having((s) => s.isAscending, 'isAscending', true),
            // estado após ToggleAlphabeticalFilterEvent (ordenado por nome)
            isA<PokemonLoaded>()
                .having(
                  (s) => s.pokemons.map((p) => p.name).toList(),
                  'ordenado por nome',
                  ['Bulbasaur', 'Charmander', 'Squirtle'],
                )
                .having((s) => s.isAlphabetical, 'isAlphabetical', true)
                // pela tua lógica, ao ligar o alfabético, desliga o numérico
                .having((s) => s.isAscending, 'isAscending', false),
          ],
    );
  });
}
