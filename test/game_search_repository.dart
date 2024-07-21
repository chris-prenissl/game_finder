import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:game_finder/data/repository/auth_repository.dart';
import 'package:game_finder/data/repository/game_search_exception.dart';
import 'package:game_finder/data/repository/game_search_repository.dart';
import 'package:game_finder/domain/model/game.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;

void main() {
  group('GameSearchRepository', () {
    late AuthRepository authRepository;
    late GameSearchRepository gameSearchRepository;
    late MockClient mockClient;

    setUp(() {
      authRepository = AuthRepository(
          clientId: 'clientId',
          clientSecret: 'clientSecret',
          tokenRequestToleranceInSeconds: 1);
      gameSearchRepository = GameSearchRepository(
          authRepository: authRepository, clientId: '1234');
    });

    test('getOrRequestToken no response body creates exception', () async {
      mockClient = MockClient((request) async {
        return http.Response(jsonEncode({'access_token' : 'token', 'expires_in': 40000}), 200);
      });
      List<Game> games = [];
      try {
        games = await gameSearchRepository.searchGames('Game', mockClient);
      } catch (e) {
        expect(e, isA<GameSearchException>());
      } finally {
        expect(games, isEmpty);
      }
    });

    tearDown(() {
      mockClient.close();
    });
  });
}
