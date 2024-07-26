import 'package:flutter_test/flutter_test.dart';
import 'package:game_finder/data/dto/game_dto.dart';
import 'package:game_finder/domain/model/game.dart';

void main() {
  group('GameDto', () {
    test('toGameEntity with missing id and missing name, throw FormatException',
        () {
      Game? game;
      try {
        final Map<String, dynamic> map = {};
        game = map.toGameEntity();
      } catch (e) {
        expect(e, isA<FormatException>());
      } finally {
        expect(game, isNull);
      }
    });

    test('toGameEntity with missing id and valid name, throw FormatException',
        () {
      Game? game;
      try {
        final Map<String, dynamic> map = {'name': 'Name'};
        game = map.toGameEntity();
      } catch (e) {
        expect(e, isA<FormatException>());
      } finally {
        expect(game, isNull);
      }
    });

    test('toGameEntity with valid id and missing name, throw FormatException',
        () {
      Game? game;
      try {
        final Map<String, dynamic> map = {'id': 1234};
        map.toGameEntity();
      } catch (e) {
        expect(e, isA<FormatException>());
      } finally {
        expect(game, isNull);
      }
    });

    test('toGameEntity with valid id and valid name, valid Game', () {
      final Map<String, dynamic> map = {'id': 1234, 'name': 'Name'};
      final result = map.toGameEntity();

      expect(result, isNotNull);
      expect(result.id, 1234);
      expect(result.name, 'Name');
    });

    test('toGameEntity with id wrong type and valid name, inValid Game',
        () {
      final Map<String, dynamic> map = {'id': '1234', 'name': 'Name'};
      Game? game;

      try {
        game = map.toGameEntity();
      } catch (e) {
        expect(e, isA<FormatException>());
      } finally {
        expect(game, isNull);
      }
    });

    test('toGameEntity with valid summary, valid Game', () {
      final Map<String, dynamic> map = {
        'id': 1234,
        'name': 'Name',
        'summary': 'Summary'
      };
      final result = map.toGameEntity();

      expect(result, isNotNull);
      expect(result.summary, equals('Summary'));
    });

    test('toGameEntity with summary wrong type, valid minimal Game', () {
      final Map<String, dynamic> map = {
        'id': 1234,
        'name': 'Name',
        'summary': 1234
      };
      final result = map.toGameEntity();

      expect(result, isNotNull);
      expect(result.summary, isNull);
    });

    test('toGameEntity with mixed valid genres map, valid Game', () {
      final Map<String, dynamic> map = {
        'id': 1234,
        'name': 'Name',
        'genres' : [{'name' : 1234}, {'name' : 'Genre'}]
      };
      final result = map.toGameEntity();

      expect(result, isNotNull);
      expect(result.genres, isNotEmpty);
      expect(result.genres.first, 'Genre');
    });

    test('toGameEntity with inValid genres map, valid Game', () {
      final Map<String, dynamic> map = {
        'id': 1234,
        'name': 'Name',
        'genres' : 1234
      };
      final result = map.toGameEntity();

      expect(result, isNotNull);
      expect(result.genres, isEmpty);
    });

    test('toGameEntity with valid coverImgUrl, valid Game', () {
      final Map<String, dynamic> map = {
        'id': 1234,
        'name': 'Name',
        'cover' : { 'url' : 'Url'}
      };
      final result = map.toGameEntity();

      expect(result, isNotNull);
      expect(result.coverImgUrl, equals('https:Url'));
    });

    test('toGameEntity with valid coverImgUrl missing url key, valid Game', () {
      final Map<String, dynamic> map = {
        'id': 1234,
        'name': 'Name',
        'cover' : {}
      };
      final result = map.toGameEntity();

      expect(result, isNotNull);
      expect(result.coverImgUrl, isNull);
    });

    test('toGameEntity with inValid coverImgUrl, valid Game', () {
      final Map<String, dynamic> map = {
        'id': 1234,
        'name': 'Name',
        'cover' : 1234
      };
      final result = map.toGameEntity();

      expect(result, isNotNull);
      expect(result.coverImgUrl, isNull);
    });

    test('toGameEntity with inValid screenShots, valid Game', () {
      final Map<String, dynamic> map = {
        'id': 1234,
        'name': 'Name',
        'screenshots' : 1234
      };
      final result = map.toGameEntity();

      expect(result, isNotNull);
      expect(result.screenShotUrls, isEmpty);
    });

    test('toGameEntity with empty screenShots, valid Game', () {
      final Map<String, dynamic> map = {
        'id': 1234,
        'name': 'Name',
        'screenshots' : {}
      };
      final result = map.toGameEntity();

      expect(result, isNotNull);
      expect(result.screenShotUrls, isEmpty);
    });

    test('toGameEntity with mixed valid screenShots, valid Game', () {
      final Map<String, dynamic> map = {
        'id': 1234,
        'name': 'Name',
        'screenshots' : [ { 'url' : 1234 }, { 'url' : 'Url'} ]
      };
      final result = map.toGameEntity();

      expect(result, isNotNull);
      expect(result.screenShotUrls.length, equals(1));
      expect(result.screenShotUrls.first, equals('https:Url'));
    });
  });
}
