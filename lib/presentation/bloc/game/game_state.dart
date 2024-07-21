part of 'game_bloc.dart';

@freezed
class GameState with _$GameState {
  const factory GameState.baseState(Game game) = _BaseState;
}
