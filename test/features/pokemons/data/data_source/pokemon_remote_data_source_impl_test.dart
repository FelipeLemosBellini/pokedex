import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex/features/pokemons/data/data_sources/interfaces/pokemon_remote_data_source.dart';
import 'package:pokedex/features/pokemons/data/data_sources/pokemon_remote_data_source_impl.dart';
import 'package:pokedex/features/pokemons/data/models/pokemon.dart';

import '../../../../core/network/mock_http_client.dart';
import '../../../../helpers/fixture_helper.dart';

Future<void> main() async {
  late MockHttpClient mockHttpClient;
  late PokemonRemoteDataSource pokemonRemoteDataSource;
  setUpAll(() {
    mockHttpClient = MockHttpClient();
    pokemonRemoteDataSource = PokemonRemoteDataSourceImpl(
      client: mockHttpClient,
    );
  });

  test("Deve retornar Success com dois itens", () async {
    String mockJsonResponse = fixture("pokemons", "pokemon");

    final response = Response(
      requestOptions: RequestOptions(path: '/master/pokedex.json'),
      data: mockJsonResponse,
      statusCode: 200,
    );

    when(
      () => mockHttpClient.get('/master/pokedex.json'),
    ).thenAnswer((_) async => response);

    final result = await pokemonRemoteDataSource.getPokemons();
    expect(result.isSuccess(), true);
    result.fold(
      (success) {
        expect(success, isA<List<Pokemon>>());
        expect(success.length, 2);
        expect(success[0].name, 'Bulbasaur');
        expect(success[1].name, 'Ivysaur');
      },
      (error) {
        fail('Não deveria retornar erro na getPokemons()');
      },
    );

    verify(() => mockHttpClient.get('/master/pokedex.json')).called(1);
  });

  test("Deve retornar Success com a lista vazia", () async {
    String mockJsonResponse = fixture("pokemons", "pokemon_response_empty");
    final response = Response(
      requestOptions: RequestOptions(path: '/master/pokedex.json'),
      data: mockJsonResponse,
      statusCode: 200,
    );

    when(
      () => mockHttpClient.get('/master/pokedex.json'),
    ).thenAnswer((_) async => response);

    final result = await pokemonRemoteDataSource.getPokemons();
    expect(result.isSuccess(), true);
    result.fold(
      (success) {
        expect(success, isA<List<Pokemon>>());
        expect(success.length, 0);
      },
      (error) {
        fail('Não deveria retornar erro na getPokemons()');
      },
    );

    verify(() => mockHttpClient.get('/master/pokedex.json')).called(1);
  });

  test("Deve retornar um Failure", () async {
    String mockJsonResponse = fixture("pokemons", "pokemon_response_error");
    final response = Response(
      requestOptions: RequestOptions(path: '/master/pokedex.json'),
      data: mockJsonResponse,
      statusCode: 400,
    );

    when(
      () => mockHttpClient.get('/master/pokedex.json'),
    ).thenAnswer((_) async => response);

    final result = await pokemonRemoteDataSource.getPokemons();
    expect(result.isError(), true);
    result.fold(
      (success) {
        fail('Não deveria retornar Success');
      },
      (error) {
        expect(error, isA<Exception>());
      },
    );

    verify(() => mockHttpClient.get('/master/pokedex.json')).called(1);
  });

  test(
    'deve retornar Failure quando ocorrer timeout (connectionTimeout)',
    () async {
      when(() => mockHttpClient.get('/master/pokedex.json')).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/master/pokedex.json'),
          type: DioExceptionType.connectionTimeout,
          message: 'Connection timeout',
        ),
      );

      final result = await pokemonRemoteDataSource.getPokemons();

      expect(result.isError(), true);
      result.fold(
        (success) => fail('Não deveria retornar sucesso em caso de timeout'),
        (error) {
          expect(error, isA<Exception>());
          expect(error.toString(), contains('Connection timeout'));
        },
      );

      verify(() => mockHttpClient.get('/master/pokedex.json')).called(1);
    },
  );
}
