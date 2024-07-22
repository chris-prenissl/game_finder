import 'dart:io';

import 'package:game_finder/data/exception/game_finder_exception.dart';

class AuthException extends GameFinderException {
  AuthException({required super.message});

  static const String requestError = 'Request error';
  static const String missingParameterMessage = 'Missing Parameter';

}
