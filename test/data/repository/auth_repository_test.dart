import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:game_finder/data/exception/auth_exception.dart';
import 'package:game_finder/data/repository/auth_repository.dart';
import 'package:game_finder/data/repository/repository_constants.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;

void main() {
  group('AuthRepository', () {
    late AuthRepository authRepository;
    late MockClient mockClient;

    setUp(() {
      authRepository = AuthRepository(
          clientId: 'clientId',
          clientSecret: 'clientSecret',
          tokenRequestToleranceInSeconds: 1);
    });

    test('getOrRequestToken no response body creates exception', () async {
      mockClient = MockClient((request) async {
        return _getInValidResponse();
      });
      try {
        await authRepository.getOrRequestToken(mockClient);
      } catch (e) {
        expect(e, isA<Exception>());
      }
    });

    test('getOrRequestToken only token creates exception', () async {
      mockClient = MockClient((request) async {
        final body = {RepositoryConstants.accessTokenBodyKey: 'token'};
        return http.Response(jsonEncode(body), 200);
      });

      String token = "";
      try {
        token = await authRepository.getOrRequestToken(mockClient);
      } catch (e) {
        expect(e, isA<AuthException>());
      } finally {
        expect(token, isEmpty);
      }
    });

    test('getOrRequestToken only expires_in creates exception', () async {
      mockClient = MockClient((request) async {
        final body = {RepositoryConstants.expiresInBodyKey: 1234};
        return http.Response(jsonEncode(body), 200);
      });

      String token = "";
      try {
        token = await authRepository.getOrRequestToken(mockClient);
      } catch (e) {
        expect(e, isA<AuthException>());
      } finally {
        expect(token, isEmpty);
      }
    });

    test('getOrRequestToken token expired with tolerance creates valid token', () async {
      MockClient firstMockClient = MockClient((request) async {
        final body = {
          RepositoryConstants.expiresInBodyKey: 0,
          RepositoryConstants.accessTokenBodyKey: 'first'
        };
        return http.Response(jsonEncode(body), 200);
      });
      MockClient secondMockClient = MockClient((request) async {
        final body = {
          RepositoryConstants.expiresInBodyKey: 500,
          RepositoryConstants.accessTokenBodyKey: 'second'
        };
        return http.Response(jsonEncode(body), 200);
      });

      String firstToken = '';
      String secondToken = '';
      try {
        firstToken = await authRepository.getOrRequestToken(firstMockClient);
        secondToken = await authRepository.getOrRequestToken(secondMockClient);
      } finally {
        firstMockClient.close();
        secondMockClient.close();

        expect(firstToken, 'first');
        expect(secondToken, 'second');
      }
    });

    test('getOrRequestToken token valid with tolerance returns still valid token', () async {
      MockClient firstMockClient = MockClient((request) async {
        final body = {
          RepositoryConstants.expiresInBodyKey: 10000,
          RepositoryConstants.accessTokenBodyKey: 'first'
        };
        return http.Response(jsonEncode(body), 200);
      });
      MockClient secondMockClient = MockClient((request) async {
        final body = {
          RepositoryConstants.expiresInBodyKey: 500,
          RepositoryConstants.accessTokenBodyKey: 'second'
        };
        return http.Response(jsonEncode(body), 200);
      });

      String firstToken = '';
      String secondToken = '';
      try {
        firstToken = await authRepository.getOrRequestToken(firstMockClient);
        secondToken = await authRepository.getOrRequestToken(secondMockClient);
      } finally {
        firstMockClient.close();
        secondMockClient.close();

        expect(firstToken, 'first');
        expect(secondToken, 'first');
      }
    });

    test('getOrRequestToken 404 error throws auth exception', () async {
      MockClient client404 = MockClient((request) async {
        return _get404();
      });

      try {
        await authRepository.getOrRequestToken(client404);
      } catch(e) {
        expect(e, isA<AuthException>());
      }
    });

    tearDown(() {
      mockClient.close();
    });
  });
}

Future<Response> _getInValidResponse() async {
  return http.Response('', 200);
}

Future<Response> _get404() async {
  return http.Response('', 404);
}
