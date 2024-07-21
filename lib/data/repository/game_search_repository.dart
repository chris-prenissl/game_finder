import 'dart:convert';

import 'package:game_finder/data/dto/game_dto.dart';
import 'package:game_finder/data/repository/auth_repository.dart';
import 'package:game_finder/data/repository/repository_constants.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'package:sprintf/sprintf.dart';

class GameSearchRepository {
  static const String igdbBaseUrl = 'api.igdb.com';
  static const String versionPath = '/v4';
  static const String path = '/games';
  static const String _query =
      "fields name, genres.*, cover.*, screenshots.*; where name = *\"%s\"*; limit 20;";

  final AuthRepository _authRepository;
  final String _clientId;

  GameSearchRepository(
      {required AuthRepository authRepository, required String clientId})
      : _authRepository = authRepository,
        _clientId = clientId;

  Future<List<GameDto>> searchGames(String searchTerm) async {
    final token = await _authRepository.getOrRequestToken();

    final client = RetryClient(http.Client());

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

    try {
      final searchResponse =
          await client.post(url, headers: headers, body: searchBody);
      final searchBodyUtf8 = utf8.decode(searchResponse.bodyBytes);
      final decodedSearchResponse = jsonDecode(searchBodyUtf8) as List;
      final games = decodedSearchResponse.map((element) {
        final name = element[RepositoryConstants.nameBodyKey];
        final genres = element['genres']?.map((genre) {
          return genre['name'];
        });
        final coverUrl = element['cover']?['url'];
        final screenshotUrls = element['screenshots']?.map((screenshot) {
          return screenshot['url'];
        });
        return GameDto(
            title: name,
            genres: [...?genres],
            coverImgUrl: coverUrl,
            screenShotUrls: [...?screenshotUrls]);
      }).nonNulls;
      return games.toList();
    } finally {
      client.close();
    }
  }
}
