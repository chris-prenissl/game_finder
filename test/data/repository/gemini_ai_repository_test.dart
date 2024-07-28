import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_finder/data/repository/gemini_ai_repository.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  
  test('getGameNameByImage', () async {
    final apiKey = dotenv.get('GEMINI_API_KEY');
    final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
    final geminiRepository = GeminiAiRepository(generativeModel: model);

    final image = await File('screenshots/game.png').readAsBytes();
    final result = await geminiRepository.getGameNameByImage(image);

    expect(result, isNotEmpty);
  });
}