import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex/features/pokemons/data/data_sources/interfaces/pokemon_local_data_source.dart';
import 'package:pokedex/features/pokemons/data/data_sources/pokemon_local_data_source_impl.dart';
import 'package:pokedex/features/pokemons/data/models/pokemon.dart';

import '../../../../core/storage/mock_local_storage.dart';
import '../../presentation/bloc/fixtures/fixture_list_pokemons.dart';

void main() {
  late PokemonLocalDataSource pokemonLocalDataSource;
  late MockLocalStorage mockLocalStorage;
  setUp(() {
    mockLocalStorage = MockLocalStorage();
    pokemonLocalDataSource = PokemonLocalDataSourceImpl(
      prefs: mockLocalStorage,
    );
  });
  group('PokemonLocalDataSourceImpl', () {
    group('cachePokemons', () {
      test('deve salvar pokemons no storage e retornar Success', () async {
        when(() => mockLocalStorage.setString(any(), any()))
            .thenAnswer((_) async => true);

        final result = await pokemonLocalDataSource.cachePokemons(allPokemons);

        expect(result.isSuccess(), true);

        final capturedKey = verify(
              () => mockLocalStorage.setString(captureAny(), captureAny()),
        ).captured;

        expect(capturedKey[0], 'POKEMONS_CACHE');

        // Verifica se o JSON foi serializado
        final capturedJson = capturedKey[1] as String;
        final decoded = jsonDecode(capturedJson) as List;
        expect(decoded.length, 3);
        expect(decoded[0]['name'], 'Charmander');
        expect(decoded[1]['name'], 'Squirtle');
        expect(decoded[2]['name'], 'Bulbasaur');
      });

      test('deve retornar Failure quando ocorrer erro ao salvar', () async {
        when(() => mockLocalStorage.setString(any(), any()))
            .thenThrow(Exception('Erro ao salvar'));

        final result = await pokemonLocalDataSource.cachePokemons(allPokemons);

        expect(result.isError(), true);
        result.fold(
              (success) => fail('Não deveria retornar sucesso'),
              (error) {
            expect(error, isA<Exception>());
            expect(error.toString(), contains('Erro ao salvar'));
          },
        );

        verify(() => mockLocalStorage.setString('POKEMONS_CACHE', any()))
            .called(1);
      });

      test('deve retornar Failure quando a serialização falhar', () async {
        when(() => mockLocalStorage.setString(any(), any()))
            .thenThrow(Exception('Erro de serialização'));

        final result = await pokemonLocalDataSource.cachePokemons(allPokemons);

        expect(result.isError(), true);
      });
    });

    group('getCachedPokemons', () {
      test('deve retornar Success com lista de pokemons quando há cache', () async {
        final jsonString = jsonEncode(
          allPokemons.map((p) => p.toJson()).toList(),
        );

        when(() => mockLocalStorage.getString('POKEMONS_CACHE'))
            .thenAnswer((_) async => jsonString);

        final result = await pokemonLocalDataSource.getCachedPokemons();

        expect(result.isSuccess(), true);
        result.fold(
              (pokemons) {
            expect(pokemons, isA<List<Pokemon>>());
            expect(pokemons.length, 3);
            expect(pokemons[0].name, 'Charmander');
            expect(pokemons[0].id, 4);
            expect(pokemons[1].name, 'Squirtle');
            expect(pokemons[1].id, 7);
          },
              (error) => fail('Não deveria retornar erro'),
        );

        verify(() => mockLocalStorage.getString('POKEMONS_CACHE')).called(1);
      });

      test('deve retornar Failure quando não há cache (null)', () async {
        when(() => mockLocalStorage.getString('POKEMONS_CACHE'))
            .thenAnswer((_) async => null);

        final result = await pokemonLocalDataSource.getCachedPokemons();

        expect(result.isError(), true);
        result.fold(
              (success) => fail('Não deveria retornar sucesso'),
              (error) {
            expect(error, isA<Exception>());
            expect(error.toString(), contains('Não há nada em cache'));
          },
        );

        verify(() => mockLocalStorage.getString('POKEMONS_CACHE')).called(1);
      });

      test('deve retornar Failure quando o JSON é inválido', () async {
        const invalidJson = 'invalid json string';

        when(() => mockLocalStorage.getString('POKEMONS_CACHE'))
            .thenAnswer((_) async => invalidJson);

        final result = await pokemonLocalDataSource.getCachedPokemons();

        expect(result.isError(), true);
        result.fold(
              (success) => fail('Não deveria retornar sucesso'),
              (error) {
            expect(error, isA<Exception>());
          },
        );

        verify(() => mockLocalStorage.getString('POKEMONS_CACHE')).called(1);
      });

      test('deve retornar Failure quando a estrutura do JSON está errada', () async {
        const wrongStructureJson = '{"data": "wrong"}';

        when(() => mockLocalStorage.getString('POKEMONS_CACHE'))
            .thenAnswer((_) async => wrongStructureJson);

        final result = await pokemonLocalDataSource.getCachedPokemons();

        expect(result.isError(), true);
        result.fold(
              (success) => fail('Não deveria retornar sucesso'),
              (error) {
            expect(error, isA<Exception>());
          },
        );
      });

      test('deve retornar Success com lista vazia quando o cache está vazio', () async {
        const emptyListJson = '[]';

        when(() => mockLocalStorage.getString('POKEMONS_CACHE'))
            .thenAnswer((_) async => emptyListJson);

        final result = await pokemonLocalDataSource.getCachedPokemons();

        expect(result.isSuccess(), true);
        result.fold(
              (pokemons) {
            expect(pokemons, isA<List<Pokemon>>());
            expect(pokemons.length, 0);
          },
              (error) => fail('Não deveria retornar erro'),
        );
      });

      test('deve retornar Failure quando getString lança exceção', () async {
        when(() => mockLocalStorage.getString('POKEMONS_CACHE'))
            .thenThrow(Exception('Erro ao ler storage'));

        final result = await pokemonLocalDataSource.getCachedPokemons();

        expect(result.isError(), true);
        result.fold(
              (success) => fail('Não deveria retornar sucesso'),
              (error) {
            expect(error, isA<Exception>());
            expect(error.toString(), contains('Erro ao ler storage'));
          },
        );
      });
    });

    group('hasCache', () {
      test('deve retornar true quando há cache', () async {
        when(() => mockLocalStorage.containsKey('POKEMONS_CACHE'))
            .thenAnswer((_) async => true);

        final result = await pokemonLocalDataSource.hasCache();

        expect(result, true);
        verify(() => mockLocalStorage.containsKey('POKEMONS_CACHE')).called(1);
      });

      test('deve retornar false quando não há cache', () async {
        when(() => mockLocalStorage.containsKey('POKEMONS_CACHE'))
            .thenAnswer((_) async => false);

        final result = await pokemonLocalDataSource.hasCache();

        expect(result, false);
        verify(() => mockLocalStorage.containsKey('POKEMONS_CACHE')).called(1);
      });
    });
  });
}
