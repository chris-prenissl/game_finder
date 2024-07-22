import 'dart:io';

class AuthException extends HttpException {
  AuthException(super.message);

  static const String requestError = 'Request error';
  static const String missingParameterMessage = 'Missing Parameter';
}
