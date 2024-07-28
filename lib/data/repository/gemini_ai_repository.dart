import 'dart:typed_data';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:sprintf/sprintf.dart';

class GeminiAiRepository {
  final GenerativeModel _generativeModel;

  GeminiAiRepository({required GenerativeModel generativeModel})
      : _generativeModel = generativeModel;

  Future<String> getGameNameByImage(Uint8List image) async {
    final descriptionPrompt = TextPart(_imageDescriptionPromptText);
    final imagePart = DataPart(_imageMimeType, image);
    final actionPrompt = TextPart(_getNameActionPrompt);

    final result = await _generativeModel.generateContent([
      Content.multi([descriptionPrompt, imagePart, actionPrompt]),
    ]);

    return result.text ?? '';
  }

  Stream<String> getDescriptionOfGame(String gameTitle) {
    final actionPrompt = sprintf(_getDescriptionActionPromptFormat, [gameTitle]);

    final stream = _generativeModel.generateContentStream([Content.text(actionPrompt)]);
    return stream.map((event) => event.text ?? '');
  }

  static const _imageDescriptionPromptText = 'Here is a image from a game';
  static const _imageMimeType = 'image/jpeg';
  static const _getNameActionPrompt = 'Give just the name of this game [only the name]';
  static const _getDescriptionActionPromptFormat = 'Give a short description of the video game %s. [Don\'t use markup styling]';
}
