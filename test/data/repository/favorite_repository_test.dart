import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:game_finder/data/repository/favorite_repository.dart';
import 'package:hive/hive.dart';

void main() {
  group('FavoriteRepository', () {
    late FavoriteRepository favoriteRepository = FavoriteRepository();

    setUp(() {
      Hive.init('${Directory.current.path}/test/data/repository');
    });

    test('isFavorite, return initial false', () async {
      final result = await favoriteRepository.isFavorite(1234);

      expect(result, equals(false));

      await Hive.deleteFromDisk();
    });

    test('toggleGameFavorite, first call return true', () async {
      await favoriteRepository.toggleGameFavorite(1234);

      final result = await favoriteRepository.isFavorite(1234);

      expect(result, equals(true));

      await Hive.deleteFromDisk();
    });

    test('toggleGameFavorite, second call return false', () async {
      await favoriteRepository.toggleGameFavorite(1234);
      await favoriteRepository.toggleGameFavorite(1234);

      final result = await favoriteRepository.isFavorite(1234);

      expect(result, equals(false));

      await Hive.deleteFromDisk();
    });

    tearDown(() async {
      await Hive.deleteFromDisk();
    });
  });
}