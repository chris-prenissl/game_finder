import 'dart:convert';
import 'dart:io';

import 'package:game_finder/data/repository/repository_constants.dart';
import 'package:http/http.dart' as http;

import '../exception/auth_exception.dart';

class AuthRepository {
  static const String authBaseUrl = 'id.twitch.tv';
  static const String authPath = '/oauth2/token';

  String? _token;
  DateTime? _tokenExpireTime;

  final String _clientId;
  final String _clientSecret;
  final int _tokenRequestToleranceInSeconds;

  AuthRepository(
      {required String clientId,
      required String clientSecret,
      required int tokenRequestToleranceInSeconds})
      : _clientId = clientId,
        _clientSecret = clientSecret,
        _tokenRequestToleranceInSeconds = tokenRequestToleranceInSeconds;

  Future<String> getOrRequestToken(http.Client client) async {
    try {
      if (!_isTokenValid()) {
        await _refreshToken(client);
      }
      return _token!;
    } catch (e) {
      if (e is IOException) {
        throw AuthException(message: AuthException.requestError);
      } else if (e is TypeError || e is FormatException) {
        throw AuthException(message: AuthException.missingParameterMessage);
      } else {
        rethrow;
      }
    }
  }

  Future<void> _refreshToken(http.Client client) async {
    final queryParams = {
      RepositoryConstants.clientIdQueryKey: _clientId,
      RepositoryConstants.clientSecretQueryKey: _clientSecret,
      RepositoryConstants.grantTypeQueryKey: RepositoryConstants.grantTypeValue
    };
    final url = Uri.https(
      authBaseUrl,
      authPath,
      queryParams,
    );

    int? expireSeconds;
    final response = await client.post(url);
    final decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    _token = decodedResponse[RepositoryConstants.accessTokenBodyKey];
    expireSeconds = decodedResponse[RepositoryConstants.expiresInBodyKey];
    _tokenExpireTime = DateTime.now().add(Duration(seconds: expireSeconds!));
  }

  bool _isTokenValid() {
    if (_tokenExpireTime == null) {
      return false;
    }
    final now = DateTime.now();
    final nowWithTolerance =
        now.add(Duration(seconds: _tokenRequestToleranceInSeconds));
    return _tokenExpireTime!.isAfter(nowWithTolerance);
  }
}
