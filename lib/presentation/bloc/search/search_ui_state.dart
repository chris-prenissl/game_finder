import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/model/game.dart';

part 'search_ui_state.freezed.dart';

@freezed
class SearchUIState with _$SearchUIState {
  const factory SearchUIState({
    required String input,
    required List<Game> foundGames,
    String? errorText,
    Game? selectedGame,
  }) = _SearchUIState;

  static const String missingInputError = 'Missing Input';
}
