import 'dart:typed_data';

import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiAiRepository {
  final GenerativeModel _generativeModel;

  GeminiAiRepository({required GenerativeModel generativeModel})
      : _generativeModel = generativeModel;

  Future<String> getGameNameByImage(Uint8List image) async {
    final descriptionPrompt = TextPart('Here is a image from a game');
    final imagePart = DataPart('image/jpeg', image);
    final actionPrompt = TextPart('Respond with only the name of this game');

    final result = await _generativeModel.generateContent([
      Content.multi([descriptionPrompt, imagePart, actionPrompt]),
    ]);

    return result.text ?? '';
  }
}
