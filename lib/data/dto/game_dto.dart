import 'package:game_finder/data/dto/util.dart';
import '../../domain/model/game.dart';

extension MapToGameEntity on Map<String, dynamic> {
  Game toGameEntity() {
    if (this case {_nameKey: String name}) {
      final summary = this[_summaryKey];
      final genres = getMappedListForKeys(_genresKey, _nameKey);
      final String? coverImgUrl = this[_coverKey]?[_urlKey] as String?;
      final String? coverImgUrlFormatted = coverImgUrl?.getFormattedImageUrl();
      final screenShotUrls = getMappedListForKeys(_screenshotsKey, _urlKey);
      return Game(
        name: name,
        summary: summary,
        genres: genres,
        coverImgUrl: coverImgUrlFormatted,
        screenShotUrls: screenShotUrls,
      );
    } else {
      throw const FormatException(_formatExceptionText);
    }
  }

  static const String _nameKey = 'name';
  static const String _summaryKey = 'summary';
  static const String _genresKey = 'genres';
  static const String _coverKey = 'cover';
  static const String _urlKey = 'url';
  static const String _screenshotsKey = 'screenshots';

  static const String _formatExceptionText = 'Failed to format to GameDto';
}