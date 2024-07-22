import 'package:game_finder/data/dto/util.dart';
import '../../domain/model/game.dart';

extension MapToGameEntity on Map<String, dynamic> {
  Game toGameEntity() {
    if (this case {_idKey: int id, _nameKey: String name}) {
      final summary = this[_summaryKey];
      final genres = getMappedListForKeys(_genresKey, _nameKey);
      final String? coverImgUrl = this[_coverKey]?[_urlKey] as String?;
      final String? coverImgUrlFormatted = coverImgUrl?.getFormattedImageUrl();
      final screenShotUrls = getMappedListForKeys(_screenshotsKey, _urlKey);
      final formattedScreenshotUrls =
          screenShotUrls.map((url) => url.getFormattedImageUrl()).toList();
      return Game(
          id: id,
          name: name,
          summary: summary,
          genres: genres,
          coverImgUrl: coverImgUrlFormatted,
          screenShotUrls: formattedScreenshotUrls,
          isFavorite: false);
    } else {
      throw const FormatException(_formatExceptionText);
    }
  }

  static const String _idKey = 'id';
  static const String _nameKey = 'name';
  static const String _summaryKey = 'summary';
  static const String _genresKey = 'genres';
  static const String _coverKey = 'cover';
  static const String _urlKey = 'url';
  static const String _screenshotsKey = 'screenshots';

  static const String _formatExceptionText = 'Failed to format to GameDto';
}
