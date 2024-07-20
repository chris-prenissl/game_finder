import 'dart:ffi';

import 'package:freezed_annotation/freezed_annotation.dart';
part 'game.freezed.dart';

@freezed
class Game with _$Game {
  const factory Game({
    required String title,
    required String description,
    required String genre,
    required String thumbnailPath,
    required List<String> imagePaths,
    required Bool isFavorite,
}) = _Game;
}