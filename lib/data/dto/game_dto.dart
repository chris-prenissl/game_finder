import 'package:game_finder/data/dto/util.dart';

class GameDto {
  final String name;
  final List<String> genres;
  final String? coverImgUrl;
  final List<String> screenShotUrls;

  GameDto(
      {required this.name,
      required this.genres,
      required this.coverImgUrl,
      required this.screenShotUrls});

  factory GameDto.fromJson(Map<String, dynamic> json) {
    if (json
        case {
          _nameKey: String name,
        }) {
      final genres = json.getMappedListForKeys(_genresKey, _nameKey);
      final String? coverImgUrl = json[_coverKey]?[_urlKey] as String?;
      final screenShotUrls =
          json.getMappedListForKeys(_screenshotsKey, _urlKey);
      return GameDto(
        name: name,
        genres: genres,
        coverImgUrl: coverImgUrl,
        screenShotUrls: screenShotUrls,
      );
    } else {
      throw const FormatException(_formatExceptionText);
    }
  }

  static const String _nameKey = 'name';
  static const String _genresKey = 'genres';
  static const String _coverKey = 'cover';
  static const String _urlKey = 'url';
  static const String _screenshotsKey = 'screenshots';

  static const String _formatExceptionText = 'Failed to format to GameDto';
}
