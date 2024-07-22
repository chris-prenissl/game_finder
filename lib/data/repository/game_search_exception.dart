import 'dart:io';

class GameSearchException extends HttpException {
  GameSearchException(super.message);

  static const String requestError = 'Request error';
  static const String wrongParametersError = 'Wrong parameters';
}
