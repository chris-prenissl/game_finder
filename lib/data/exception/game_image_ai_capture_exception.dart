import 'package:game_finder/data/exception/game_finder_exception.dart';

class GameImageAiCaptureException extends GameFinderException {
  GameImageAiCaptureException({required super.message});

  static const cameraError = 'Camera Error';
  static const aiError = 'Could not send ai request';
}