import 'dart:convert';
import 'dart:io';

import 'package:game_finder/data/dto/game_dto.dart';
import 'package:game_finder/data/repository/auth_repository.dart';
import 'package:game_finder/data/repository/favorite_repository.dart';
import 'package:game_finder/data/exception/game_search_exception.dart';
import 'package:game_finder/data/repository/repository_constants.dart';
import 'package:http/http.dart' as http;
import 'package:sprintf/sprintf.dart';

import '../../domain/model/game.dart';

class GameSearchRepository {
  static const String igdbBaseUrl = 'api.igdb.com';
  static const String versionPath = '/v4';
  static const String path = '/games';
  static const String _query =
      "fields name, summary, genres.*, cover.*, screenshots.*; where name = *\"%s\"*; limit 50;";

  final AuthRepository _authRepository;
  final FavoriteRepository _favoriteRepository;
  final String _clientId;

  GameSearchRepository(
      {required AuthRepository authRepository,
      required FavoriteRepository favoriteRepository,
      required String clientId})
      : _authRepository = authRepository,
        _favoriteRepository = favoriteRepository,
        _clientId = clientId;

  Future<List<Game>> searchGames(String searchTerm, http.Client client) async {
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

    try {
      final searchResponse =
          await client.post(url, headers: headers, body: searchBody);
      if (searchResponse.statusCode != 200) {
        throw GameSearchException(message: GameSearchException.requestError);
      }
      final searchBodyUtf8 = utf8.decode(searchResponse.bodyBytes);
      final decodedSearchResponse = jsonDecode(searchBodyUtf8);
      if (decodedSearchResponse is! List) {
        throw const FormatException();
      }

      final games = decodedSearchResponse
          .whereType<Map<String, dynamic>>()
          .map((Map<String, dynamic> element) => element.toGameEntity())
          .toList();

      final List<Game> gamesWithFavorite = [];
      for (final game in games) {
        final isFavorite = await _favoriteRepository.isFavorite(game.id);
        gamesWithFavorite.add(game.copyWith(isFavorite: isFavorite));
      }

      return gamesWithFavorite;
    } catch (e) {
      if (e is IOException) {
        throw GameSearchException(message: GameSearchException.requestError);
      }
      if (e is FormatException) {
        throw GameSearchException(message: GameSearchException.formatError);
      }
      rethrow;
    } finally {
      client.close();
    }
  }
}
