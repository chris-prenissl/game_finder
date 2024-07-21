import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:game_finder/data/repository/game_search_repository.dart';
import 'package:game_finder/presentation/bloc/search/search_ui_state.dart';
import 'package:http/retry.dart';
import 'package:http/http.dart' as http;

part 'search_event.dart';

part 'search_state.dart';

part 'search_bloc.freezed.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchUIState _uiState =
      const SearchUIState(input: '', foundGames: [], errorText: '');

  final GameSearchRepository _gameSearchRepository;

  SearchBloc(this._gameSearchRepository)
      : super(const _Result(
            uiState: SearchUIState(input: '', foundGames: [], errorText: ''))) {
    on<_InputChange>((event, emit) {
      _uiState = _uiState.copyWith(input: event.input);
      emit(_Result(uiState: _uiState));
    });
    on<_Search>((event, emit) async {
      emit(_Searching(uiState: _uiState));

      final games = await _gameSearchRepository.searchGames(
          _uiState.input.trim(), RetryClient(http.Client()));
      _uiState = _uiState.copyWith(foundGames: games);

      emit(_Result(uiState: _uiState));
    });
  }
}
