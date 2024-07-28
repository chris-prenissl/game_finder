part of 'game_bloc.dart';

@freezed
class GameState with _$GameState {
  const factory GameState.result(Game game) = _Result;
  const factory GameState.loading(Game game) = _Loading;
  const factory GameState.partialAiResponse(Game game) = _PartialAiResponse;
}
