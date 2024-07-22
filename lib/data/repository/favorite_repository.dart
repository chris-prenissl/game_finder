import 'package:hive/hive.dart';

class FavoriteRepository {
  Future<void> storeGameFavoriteId(int id) async {
    final box = await Hive.openBox(_favoriteTable);
    box.put(id, true);
  }

  Future<void> removeGameFavoriteId(int id) async {
    final box = await Hive.openBox(_favoriteTable);
    box.delete(id);
  }

  Future<bool> isFavorite(int id) async {
    final box = await Hive.openBox(_favoriteTable);
    return box.get(id, defaultValue: false);
  }

  static const String _favoriteTable = 'favorite';
}
