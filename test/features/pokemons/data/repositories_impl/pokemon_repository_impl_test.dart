import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex/features/pokemons/data/repositories_impl/pokemon_repository_impl.dart';
import 'package:pokedex/features/pokemons/domain/repositories/pokemon_repository_interface.dart';
import 'package:result_dart/result_dart.dart';

import 'package:pokedex/features/pokemons/data/models/enum/type_of_pokemon.dart';

import '../../../../core/connectivity/mock_network_info.dart';
import '../../presentation/bloc/fixtures/fixture_list_pokemons.dart';
import '../data_source/mock_local_data_source.dart';
import '../data_source/mock_remote_data_source.dart';

void main() {
  late MockRemoteDataSource mockRemote;
  late MockLocalDataSource mockLocal;
  late MockNetworkInfo mockNetworkInfo;
  late PokemonRepositoryInterface repository;

  setUp(() {
    mockRemote = MockRemoteDataSource();
    mockLocal = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();

    repository = PokemonRepositoryImpl(
      pokemonRemoteDataSource: mockRemote,
      pokemonLocalDataSource: mockLocal,
      networkInfo: mockNetworkInfo,
    );
  });

  group('getPokemons', () {
    test(
      'online, sem cache -> busca do remoto, faz cache e retorna sucesso',
      () async {
        // Arrange
        when(() => mockLocal.hasCache()).thenAnswer((_) async => false);
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          () => mockRemote.getPokemons(),
        ).thenAnswer((_) async => Success(allPokemons));
        when(
          () => mockLocal.cachePokemons(allPokemons),
        ).thenAnswer((_) async => Success(unit));

        final result = await repository.getPokemons();

        expect(result.isSuccess(), true);
        result.fold((list) {
          expect(list, allPokemons);
        }, (error) => fail('Não deveria falhar'));

        verify(() => mockLocal.hasCache()).called(1);
        verify(() => mockNetworkInfo.isConnected).called(1);
        verify(() => mockRemote.getPokemons()).called(1);
        verify(() => mockLocal.cachePokemons(allPokemons)).called(1);
        verifyNever(() => mockLocal.getCachedPokemons());
      },
    );

    test(
      'online, com cache, mas refresh = true -> força remoto, faz cache e retorna sucesso',
      () async {
        when(() => mockLocal.hasCache()).thenAnswer((_) async => true);
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          () => mockRemote.getPokemons(),
        ).thenAnswer((_) async => Success(allPokemons));
        when(
          () => mockLocal.cachePokemons(allPokemons),
        ).thenAnswer((_) async => Success(unit));

        final result = await repository.getPokemons(refresh: true);

        // Assert
        expect(result.isSuccess(), true);
        result.fold(
          (list) => expect(list, allPokemons),
          (error) => fail('Não deveria falhar'),
        );

        verify(() => mockLocal.hasCache()).called(1);
        verify(() => mockNetworkInfo.isConnected).called(1);
        verify(() => mockRemote.getPokemons()).called(1);
        verify(() => mockLocal.cachePokemons(allPokemons)).called(1);
        verifyNever(() => mockLocal.getCachedPokemons());
      },
    );

    test(
      'online, mas remoto falha -> retorna Failure com o mesmo erro, não chama cache',
      () async {
        final remoteError = Exception('Erro remoto');

        when(() => mockLocal.hasCache()).thenAnswer((_) async => false);
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          () => mockRemote.getPokemons(),
        ).thenAnswer((_) async => Failure(remoteError));

        final result = await repository.getPokemons();

        // Assert
        expect(result.isError(), true);
        result.fold((success) => fail('Não deveria ter sucesso'), (error) {
          expect(error, same(remoteError));
        });

        verify(() => mockLocal.hasCache()).called(1);
        verify(() => mockNetworkInfo.isConnected).called(1);
        verify(() => mockRemote.getPokemons()).called(1);
        verifyNever(() => mockLocal.getCachedPokemons());
      },
    );

    test('offline -> retorna o resultado de getCachedPokemons()', () async {
      when(() => mockLocal.hasCache()).thenAnswer((_) async => true);
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(
        () => mockLocal.getCachedPokemons(),
      ).thenAnswer((_) async => Success(allPokemons));

      final result = await repository.getPokemons();

      // Assert
      expect(result.isSuccess(), true);
      result.fold(
        (list) => expect(list, allPokemons),
        (error) => fail('Não deveria falhar'),
      );

      verify(() => mockLocal.hasCache()).called(1);
      verify(() => mockNetworkInfo.isConnected).called(1);
      verifyNever(() => mockRemote.getPokemons());
      verify(() => mockLocal.getCachedPokemons()).called(1);
    });

    test(
      'offline e cache falha -> retorna Failure com erro do local',
      () async {
        final localError = Exception('Erro local');

        when(() => mockLocal.hasCache()).thenAnswer((_) async => true);
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        when(
          () => mockLocal.getCachedPokemons(),
        ).thenAnswer((_) async => Failure(localError));

        final result = await repository.getPokemons();

        // Assert
        expect(result.isError(), true);
        result.fold(
          (success) => fail('Não deveria ter sucesso'),
          (error) => expect(error, same(localError)),
        );

        verify(() => mockLocal.hasCache()).called(1);
        verify(() => mockNetworkInfo.isConnected).called(1);
        verifyNever(() => mockRemote.getPokemons());
        verify(() => mockLocal.getCachedPokemons()).called(1);
      },
    );

    test(
      'qualquer exceção inesperada no try/catch -> retorna Failure(Exception)',
      () async {
        when(() => mockLocal.hasCache()).thenThrow(Exception('Bug qualquer'));

        final result = await repository.getPokemons();

        expect(result.isError(), true);
        result.fold(
          (success) => fail('Não deveria ter sucesso'),
          (error) => expect(error, isA<Exception>()),
        );

        verify(() => mockLocal.hasCache()).called(1);
      },
    );
  });

  group('searchPokemons', () {
    test('filtra por nome (case-insensitive, contains)', () async {
      when(
        () => mockLocal.getCachedPokemons(),
      ).thenAnswer((_) async => Success(allPokemons));

      final result = await repository.searchPokemons(value: 'bulb');

      expect(result.isSuccess(), true);
      result.fold((list) {
        expect(list.length, 1);
        expect(list.first.name, 'Bulbasaur');
      }, (error) => fail('Não deveria falhar'));

      verify(() => mockLocal.getCachedPokemons()).called(1);
    });

    test('filtra por id numérico (ex: "4" -> Charmander)', () async {
      when(
        () => mockLocal.getCachedPokemons(),
      ).thenAnswer((_) async => Success(allPokemons));

      final result = await repository.searchPokemons(value: '004');

      expect(result.isSuccess(), true);
      result.fold((list) {
        expect(list.length, 1);
        expect(list.first.name, 'Charmander');
      }, (error) => fail('Não deveria falhar'));
    });

    test('filtra por number exato ou com padLeft (ex: "1" ou "001")', () async {
      when(
        () => mockLocal.getCachedPokemons(),
      ).thenAnswer((_) async => Success(allPokemons));

      // "1" deve bater com "001"
      final result = await repository.searchPokemons(value: '1');

      expect(result.isSuccess(), true);
      result.fold((list) {
        expect(list.length, 1);
        expect(list.first.name, 'Bulbasaur');
      }, (error) => fail('Não deveria falhar'));
    });

    test('erro ao pegar cache -> retorna Failure com erro do local', () async {
      final localError = Exception('Erro cache search');

      when(
        () => mockLocal.getCachedPokemons(),
      ).thenAnswer((_) async => Failure(localError));

      final result = await repository.searchPokemons(value: 'qualquer');

      expect(result.isError(), true);
      result.fold(
        (success) => fail('Não deveria ter sucesso'),
        (error) => expect(error, same(localError)),
      );
    });

    test(
      'exceção inesperada no try/catch de search -> retorna Failure(Exception)',
      () async {
        when(
          () => mockLocal.getCachedPokemons(),
        ).thenThrow(Exception('Bug search'));

        final result = await repository.searchPokemons(value: 'bulba');

        expect(result.isError(), true);
        result.fold(
          (success) => fail('Não deveria ter sucesso'),
          (error) => expect(error, isA<Exception>()),
        );
      },
    );
  });

  group('getRelated', () {
    test(
      'retorna apenas pokemons com ao menos 1 tipo em comum, ordenados por matches',
      () async {
        when(
          () => mockLocal.getCachedPokemons(),
        ).thenAnswer((_) async => Success(allPokemons));

        final types = [TypeOfPokemon.fire];

        final result = await repository.getRelated(listOfType: types);

        expect(result.isSuccess(), true);
        result.fold((list) {
          expect(list.length, 1);
          final names = list.map((p) => p.name).toList();
          expect(names, containsAll(['Charmander']));

          // Todos têm 1 match com types (grass ou fire)
          // bulbasaur: grass
          // ivysaur: grass
          // charmander: fire
          // Todos com 1 match -> a ordenação entre eles é livre,
          // mas pelo menos garantimos que pikachu ficou de fora.
          expect(names.contains('Pikachu'), false);
        }, (error) => fail('Não deveria falhar'));

        verify(() => mockLocal.getCachedPokemons()).called(1);
      },
    );

    test('erro no cache -> retorna Failure com erro do local', () async {
      final localError = Exception('Erro cache related');

      when(
        () => mockLocal.getCachedPokemons(),
      ).thenAnswer((_) async => Failure(localError));

      final result = await repository.getRelated(
        listOfType: [TypeOfPokemon.grass],
      );

      expect(result.isError(), true);
      result.fold(
        (success) => fail('Não deveria ter sucesso'),
        (error) => expect(error, same(localError)),
      );
    });

    test(
      'exceção inesperada no try/catch de getRelated -> retorna Failure(Exception)',
      () async {
        when(
          () => mockLocal.getCachedPokemons(),
        ).thenThrow(Exception('Bug related'));

        final result = await repository.getRelated(
          listOfType: [TypeOfPokemon.grass],
        );

        expect(result.isError(), true);
        result.fold(
          (success) => fail('Não deveria ter sucesso'),
          (error) => expect(error, isA<Exception>()),
        );
      },
    );
  });
}
