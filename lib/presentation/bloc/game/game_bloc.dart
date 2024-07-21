import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/model/game.dart';

part 'game_event.dart';
part 'game_state.dart';
part 'game_bloc.freezed.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  Game _game;

  GameBloc(this._game) : super(GameState.baseState(_game)) {
    on<_ToggleFavorite>((event, emit) {
      _game = _game.copyWith(isFavorite: !_game.isFavorite);
      emit(GameState.baseState(_game));
    });
  }
}
