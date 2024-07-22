import 'package:freezed_annotation/freezed_annotation.dart';
part 'game.freezed.dart';

@freezed
class Game with _$Game {
  const factory Game({
    required int id,
    required String name,
    required String? summary,
    required List<String> genres,
    required String? coverImgUrl,
    required List<String> screenShotUrls,
    required bool isFavorite
}) = _Game;
}