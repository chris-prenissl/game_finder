part of 'game_bloc.dart';

@freezed
class GameEvent with _$GameEvent {
  const factory GameEvent.toggleFavorite() = _ToggleFavorite;
}
