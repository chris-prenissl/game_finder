import 'package:hive/hive.dart';

class FavoriteRepository {
  Future<void> toggleGameFavorite(int id) async {
    final favorite = await isFavorite(id);
    if (favorite) {
      await _removeGameFavoriteId(id);
    } else {
      await _storeGameFavoriteId(id);
    }
  }

  Future<void> _storeGameFavoriteId(int id) async {
    final box = await Hive.openBox(_favoriteTable);
    box.put(id, true);
  }

  Future<void> _removeGameFavoriteId(int id) async {
    final box = await Hive.openBox(_favoriteTable);
    box.delete(id);
  }

  Future<bool> isFavorite(int id) async {
    final box = await Hive.openBox(_favoriteTable);
    return box.get(id, defaultValue: false);
  }

  static const String _favoriteTable = 'favorite';
}
