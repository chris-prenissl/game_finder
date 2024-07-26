import 'package:flutter_test/flutter_test.dart';
import 'package:game_finder/data/dto/game_dto.dart';
import 'package:game_finder/data/dto/util.dart';

void main() {
  group('util', () {

    test('ImageUrlFormatter getFormattedImageUrl with not empty string, result https:<value>', () {
      final result = '//example.com'.getFormattedImageUrl();

      expect(result, equals('https://example.com'));
    });

    test('ImageUrlFormatter getFormattedImageUrl with empty string, result https:', () {
      final result = ''.getFormattedImageUrl();

      expect(result, equals('https:'));
    });
  });
}