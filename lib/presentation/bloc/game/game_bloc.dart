import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:game_finder/data/repository/favorite_repository.dart';
import 'package:game_finder/data/repository/gemini_ai_repository.dart';

import '../../../domain/model/game.dart';

part 'game_event.dart';

part 'game_state.dart';

part 'game_bloc.freezed.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  Game _game;
  final FavoriteRepository _favoriteRepository;
  final GeminiAiRepository _geminiAiRepository;

  GameBloc(this._game, this._favoriteRepository, this._geminiAiRepository)
      : super(GameState.result(_game)) {
    on<_ToggleFavorite>((event, emit) async {
      await _favoriteRepository.toggleGameFavorite(_game.id);
      _game = _game.copyWith(isFavorite: !_game.isFavorite);
      emit(GameState.result(_game));
    });
    on<_RequestAiDescription>((event, emit) async {
      emit(GameState.loading(_game));
      _game = _game.copyWith(aiDescription: null);

      final descriptionStream =
          _geminiAiRepository.getDescriptionOfGame(_game.name);
      await for (final response in descriptionStream) {
        String newDescription = _game.aiDescription ?? '';
        newDescription += response;
        _game = _game.copyWith(aiDescription: newDescription);
        emit(GameState.partialAiResponse(_game));
      }
      emit(GameState.result(_game));
    });
  }
}
