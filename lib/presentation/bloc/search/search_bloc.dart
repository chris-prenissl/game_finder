import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:game_finder/presentation/bloc/search/search_ui_state.dart';

part 'search_event.dart';

part 'search_state.dart';

part 'search_bloc.freezed.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchUIState _uiState =
      const SearchUIState(input: '', foundGames: [], errorText: '');

  SearchBloc()
      : super(const _Result(
            uiState: SearchUIState(input: '', foundGames: [], errorText: ''))) {
    on<_InputChange>((event, emit) {
      _uiState = _uiState.copyWith(input: event.input);
      emit(_Result(uiState: _uiState));
    });
    on<_Search>((event, emit) {
      emit(_Searching(uiState: _uiState));
    });
  }
}
