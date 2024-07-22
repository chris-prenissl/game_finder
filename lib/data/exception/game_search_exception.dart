import 'dart:io';

import 'package:game_finder/data/exception/game_finder_exception.dart';

class GameSearchException extends GameFinderException {
  GameSearchException({required super.message});

  static const String requestError = 'Request error';
  static const String wrongParametersError = 'Wrong parameters';

}
