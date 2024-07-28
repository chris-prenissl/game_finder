import 'package:game_finder/data/exception/game_finder_exception.dart';

class AuthException extends GameFinderException {
  AuthException({required super.message});

  static const String requestError = 'Authentication: request error';
  static const String missingParameterMessage = 'Authentication: Missing Parameter';
}
