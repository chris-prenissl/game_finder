part of 'search_bloc.dart';

@freezed
class SearchState with _$SearchState {
  const factory SearchState.searching({required SearchUIState uiState}) = _Searching;
  const factory SearchState.result({required SearchUIState uiState}) = _Result;
  const factory SearchState.error({required SearchUIState uiState}) = _Error;
}
