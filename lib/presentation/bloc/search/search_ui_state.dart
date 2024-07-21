import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:game_finder/data/dto/game_dto.dart';
import '../../../domain/model/game.dart';

part 'search_ui_state.freezed.dart';

@freezed
class SearchUIState with _$SearchUIState {
  const factory SearchUIState({
    required String input,
    required List<GameDto> foundGames,
    required String errorText,
}) = _SearchUIState;
}