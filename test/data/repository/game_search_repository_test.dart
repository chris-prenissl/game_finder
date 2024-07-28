import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:game_finder/data/repository/auth_repository.dart';
import 'package:game_finder/data/exception/game_search_exception.dart';
import 'package:game_finder/data/repository/favorite_repository.dart';
import 'package:game_finder/data/repository/game_search_repository.dart';
import 'package:game_finder/domain/model/game.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;

void main() {
  group('GameSearchRepository', () {
    late AuthRepository authRepository;
    late FavoriteRepository favoriteRepository;
    late GameSearchRepository gameSearchRepository;
    late MockClient mockClient;

    setUp(() async {
      Hive.init('${Directory.current.path}/test/data/repository/hive_game_search_test');
      favoriteRepository = FavoriteRepository();
      authRepository = AuthRepository(
          clientId: 'clientId',
          clientSecret: 'clientSecret',
          tokenRequestToleranceInSeconds: 1);
      gameSearchRepository = GameSearchRepository(
          authRepository: authRepository,
          clientId: '1234',
          favoriteRepository: favoriteRepository);
    });

    test(
        'getOrRequestToken authenticated, valid auth response and gameSearch no response body, creates exception',
        () async {
      mockClient = MockClient((request) async {
        if (request.url.path == '/oauth2/token') {
          return _getValidAuthResponse();
        }
        if (request.url.path == '/v4/games') {
          return _getInValidResponse();
        }
        return http.Response('', 500);
      });
      List<Game> result = [];
      try {
        result = await gameSearchRepository.searchGames('Game', mockClient);
      } catch (e) {
        expect(e, isA<GameSearchException>());
      } finally {
        expect(result, isEmpty);
      }
    });

    test(
        'getOrRequestToken authenticated, valid auth response and valid gameSearch body, creates exception',
        () async {
      mockClient = MockClient((request) async {
        if (request.url.path == '/oauth2/token') {
          return _getValidAuthResponse();
        }
        if (request.url.path == '/v4/games') {
          return _getValidGamesResponse();
        }
        return http.Response('', 500);
      });
      final result = await gameSearchRepository.searchGames('Game', mockClient);

      expect(result.length, equals(1));
      expect(result.first.id, equals(1234));
      expect(result.first.name, equals('Game'));
    });

    test(
        'getOrRequestToken authenticated, valid auth response and 404 error gameSearch body, creates exception',
        () async {
      mockClient = MockClient((request) async {
        if (request.url.path == '/oauth2/token') {
          return _getValidAuthResponse();
        }
        if (request.url.path == '/v4/games') {
          return _get404();
        }
        return http.Response('', 500);
      });

      List<Game> result = [];
      try {
        result = await gameSearchRepository.searchGames('Game', mockClient);
      } catch (e) {
        expect(e, isA<GameSearchException>());
      } finally {
        expect(result, isEmpty);
      }
    });

    tearDown(() async {
      mockClient.close();
      await Hive.deleteFromDisk();
    });
  });
}

Future<Response> _getValidAuthResponse() async {
  return http.Response(
      jsonEncode({'access_token': 'token', 'expires_in': 40000}), 200);
}

Future<Response> _getInValidResponse() async {
  return http.Response('', 200);
}

Future<Response> _getValidGamesResponse() async {
  return http.Response(
      jsonEncode([
        {'id': 1234, 'name': 'Game'}
      ]),
      200);
}

Future<Response> _get404() async {
  return http.Response('', 404);
}
