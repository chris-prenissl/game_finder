import 'package:game_finder/data/exception/game_finder_exception.dart';

class GameSearchException extends GameFinderException {
  GameSearchException({required super.message});

  static const String requestError = 'GameSearch: Request error';
  static const String formatError = 'Game Search: Response could not be ';
}
