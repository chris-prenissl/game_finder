import 'dart:convert';

import 'package:game_finder/data/repository/repository_constants.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';

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

  Future<String> getOrRequestToken() async {
    if (!_isTokenValid()) {
      await _refreshToken();
    }
    return _token!;
  }

  Future<void> _refreshToken() async {
    final client = RetryClient(http.Client());
    final queryParams = {
      RepositoryConstants.clientIdQueryKey : _clientId,
      RepositoryConstants.clientSecretQueryKey : _clientSecret,
      RepositoryConstants.grantTypeQueryKey : RepositoryConstants.grantTypeValue
    };
    final url = Uri.https(
      authBaseUrl,
      authPath,
      queryParams,
    );
    try {
      final response = await client.post(url);
      final decodedResponse =
          jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      _token = decodedResponse[RepositoryConstants.accessTokenBodyKey];
      final expireSeconds = decodedResponse[RepositoryConstants.expiresInBodyKey];
      _tokenExpireTime = DateTime.now().add(Duration(seconds: expireSeconds));
    } finally {
      client.close();
    }
  }

  bool _isTokenValid() {
    if (_tokenExpireTime == null) {
      return false;
    }
    return DateTime.now().isAfter(_tokenExpireTime!
        .add(Duration(seconds: _tokenRequestToleranceInSeconds)));
  }
}
