import 'package:flutter_test/flutter_test.dart';
import 'package:game_finder/data/dto/util.dart';

void main() {
  group('IGDBImageUrlFormatter', () {
    test(
        'ImageUrlFormatter getFormattedImageUrl with not empty string, result https:<value>',
        () {
      final result = '//example.com'.getFormattedImageUrl();

      expect(result, equals('https://example.com'));
    });

    test(
        'ImageUrlFormatter getFormattedImageUrl with empty string, result https:',
        () {
      final result = ''.getFormattedImageUrl();

      expect(result, equals('https:'));
    });
  });

  group('MapParising', () {

    test('getStringValue, value not String, result null', () {
      final map = {'key': null };
      final result = map.getStringValue('key');

      expect(result, isNull);
    });

    test('getStringValue, value is String, result valid String', () {
      final map = {'key': 'Value' };
      final result = map.getStringValue('key');

      expect(result, equals('Value'));
    });

    test('getStringMapValue, value not Map<String, dynamic>, result null', () {
      final map = {'mainKey': 1234};
      final result = map.getStringMapValue('mainKey', 'key');

      expect(result, isNull);
    });

    test('getStringMapValue, mapValue not String, result null', () {
      final map = {'mainKey': { 'key' : 1234 }};
      final result = map.getStringMapValue('mainKey', 'key');

      expect(result, isNull);
    });

    test('getStringMapValue, mapValue is valid String, result null', () {
      final map = {'mainKey': { 'key' : 'mapValue' }};
      final result = map.getStringMapValue('mainKey', 'key');

      expect(result, equals('mapValue'));
    });

    test('getMappedStringListForKeys, value null, result valid list', () {
      final map = {
        'mainKey': [
          {'key': 1234},
          {'key': 'valid'}
        ]
      };
      final result = map.getMappedStringListForKeys('wrongKey', 'key');

      expect(result, isNotNull);
      expect(result, isEmpty);
    });

    test('getMappedStringListForKeys, value is no Iterable, result valid list',
        () {
      final map = {'mainKey': 1234};
      final result = map.getMappedStringListForKeys('mainKey', 'key');

      expect(result, isNotNull);
      expect(result, isEmpty);
    });

    test(
        'getMappedStringListForKeys, one value wrong type and one value valid type, result valid list',
        () {
      final map = {
        'mainKey': [
          {'key': 1234},
          {'key': 'valid'}
        ]
      };
      final result = map.getMappedStringListForKeys('mainKey', 'key');

      expect(result, isNotNull);
      expect(result, isNotEmpty);
      expect(result.first, 'valid');
    });
  });
}
