import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:game_finder/data/repository/game_search_repository.dart';
import 'package:game_finder/presentation/bloc/search/search_ui_state.dart';
import 'package:http/retry.dart';
import 'package:http/http.dart' as http;

import '../../../data/exception/game_finder_exception.dart';
import '../../../domain/model/game.dart';

part 'search_event.dart';

part 'search_state.dart';

part 'search_bloc.freezed.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  static const SearchUIState _initialState =
      SearchUIState(input: '', foundGames: [], errorText: null);
  SearchUIState _uiState = _initialState;

  final GameSearchRepository _gameSearchRepository;

  SearchBloc(this._gameSearchRepository)
      : super(const _Result(uiState: _initialState)) {
    on<_InputChange>((event, emit) {
      _resetErrorText();
      _uiState = _uiState.copyWith(input: event.input);
      emit(_Result(uiState: _uiState));
    });
    on<_Search>((_, emit) async {
      if (_uiState.input.isEmpty) {
        _uiState =
            _uiState.copyWith(errorText: SearchUIState.missingInputError);
        emit(_Result(uiState: _uiState));
        return;
      }
      _resetErrorText();
      emit(_Searching(
        uiState: _uiState,
      ));

      try {
        final games = await _gameSearchRepository.searchGames(
            _uiState.input.trim(), RetryClient(http.Client()));
        _uiState = _uiState.copyWith(foundGames: games);
      } catch (e) {
        if (e is GameFinderException) {
          _uiState = _uiState.copyWith(errorText: e.message);
          emit(_Result(uiState: _uiState));
        } else {
          rethrow;
        }
      }

      emit(_Result(uiState: _uiState));
    });
    on<_SetFavorite>((event, emit) async {
      List<Game> foundGames = [..._uiState.foundGames];
      for (var i = 0; i < foundGames.length; i++) {
        final game = foundGames[i];
        if (game.id == event.gameId) {
          foundGames[i] = game.copyWith(isFavorite: event.isFavorite);
          break;
        }
      }

      _uiState = _uiState.copyWith(foundGames: foundGames);
      emit(_Result(uiState: _uiState));
    });
  }

  void _resetErrorText() {
    _uiState = _uiState.copyWith(errorText: null);
  }
}
