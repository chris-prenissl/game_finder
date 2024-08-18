import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_finder/data/repository/gemini_ai_repository.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

void main() async {
  late String apiKey;
  late GenerativeModel model;
  late GeminiAiRepository geminiRepository;

  setUp(() async {
    await dotenv.load(fileName: ".env");

    apiKey = dotenv.get('GEMINI_API_KEY');
    model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
    geminiRepository = GeminiAiRepository(generativeModel: model);
  });
  
  test('getGameNameByImage', () async {
    final image = await File('screenshots/search.png').readAsBytes();
    final result = await geminiRepository.getGameNameByImage(image);

    expect(result, isNotEmpty);
  });

  test('getDescriptionOfGame', () async {
    final stream = geminiRepository.getDescriptionOfGame('Game');
    String result = "";
    await for (final response in stream) {
      result += response;
    }

    expect(result, isNotEmpty);
  });
}