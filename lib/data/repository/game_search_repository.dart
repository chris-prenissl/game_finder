import 'dart:convert';

import 'package:game_finder/data/dto/game_dto.dart';
import 'package:game_finder/data/repository/auth_repository.dart';
import 'package:game_finder/data/repository/repository_constants.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'package:sprintf/sprintf.dart';

import '../../domain/model/game.dart';

class GameSearchRepository {
  static const String igdbBaseUrl = 'api.igdb.com';
  static const String versionPath = '/v4';
  static const String path = '/games';
  static const String _query =
      "fields name, genres.*, cover.*, screenshots.*; where name = *\"%s\"*; limit 50;";

  final AuthRepository _authRepository;
  final String _clientId;

  GameSearchRepository(
      {required AuthRepository authRepository, required String clientId})
      : _authRepository = authRepository,
        _clientId = clientId;

  Future<List<Game>> searchGames(String searchTerm, http.Client client) async {
    try {
      final token = await _authRepository.getOrRequestToken(client);

      final headers = {
        RepositoryConstants.clientIdHeaderKey: _clientId,
        RepositoryConstants.authorizationHeaderKey:
            "${RepositoryConstants.bearer} $token",
      };
      final url = Uri.https(
        igdbBaseUrl,
        versionPath + path,
      );
      final searchBody = sprintf(_query, [searchTerm]);

      final searchResponse =
          await client.post(url, headers: headers, body: searchBody);
      final searchBodyUtf8 = utf8.decode(searchResponse.bodyBytes);
      final decodedSearchResponse = jsonDecode(searchBodyUtf8) as List;

      final games = decodedSearchResponse
          .whereType<Map<String, dynamic>>()
          .map((Map<String, dynamic> element) => element.toGameEntity())
          .toList();
      return games;
    } finally {
      client.close();
    }
  }
}