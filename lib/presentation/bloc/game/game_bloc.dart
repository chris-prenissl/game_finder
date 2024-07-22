import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:game_finder/data/repository/favorite_repository.dart';

import '../../../domain/model/game.dart';

part 'game_event.dart';

part 'game_state.dart';

part 'game_bloc.freezed.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  Game _game;
  final FavoriteRepository _favoriteRepository;

  GameBloc(this._game, this._favoriteRepository)
      : super(GameState.baseState(_game)) {
    on<_ToggleFavorite>((event, emit) {
      _game = _game.copyWith(isFavorite: !_game.isFavorite);
      final id = _game.id;
      if (_game.isFavorite) {
        _favoriteRepository.storeGameFavoriteId(id);
      } else {
        _favoriteRepository.removeGameFavoriteId(id);
      }

      emit(GameState.baseState(_game));
    });
  }
}
