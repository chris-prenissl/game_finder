part of 'search_bloc.dart';

@freezed
class SearchEvent with _$SearchEvent {
  const factory SearchEvent.inputChange(String input) = _InputChange;
  const factory SearchEvent.search() = _Search;
}
