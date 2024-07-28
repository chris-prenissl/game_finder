import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_finder/data/exception/auth_exception.dart';
import 'package:game_finder/data/repository/game_search_repository.dart';
import 'package:game_finder/domain/model/game.dart';
import 'package:game_finder/presentation/bloc/search/search_bloc.dart';
import 'package:game_finder/presentation/bloc/search/search_ui_state.dart';
import 'package:hive/hive.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'search_bloc_test.mocks.dart';

@GenerateNiceMocks([MockSpec<GameSearchRepository>()])
void main() {
  group('SearchBloc', () {
    List<Game> searchedGames = [
      const Game(
          id: 1234,
          name: 'Game',
          summary: null,
          genres: [],
          coverImgUrl: null,
          screenShotUrls: [],
          isFavorite: false)
    ];
    late MockGameSearchRepository mockGameSearchRepository;

    setUp(() {
      mockGameSearchRepository = MockGameSearchRepository();
    });

    test('initial state', () {
      final searchBloc = SearchBloc(mockGameSearchRepository);
      final result = searchBloc.state;
      final uiState = result.uiState;
      expect(uiState.input, isEmpty);
      expect(uiState.foundGames, isEmpty);
      expect(uiState.errorText, isNull);
    });

    blocTest(
      'Input change returns uiState with changed input',
      build: () => SearchBloc(mockGameSearchRepository),
      act: (bloc) {
        bloc.add(const SearchEvent.inputChange('G'));
        bloc.add(const SearchEvent.inputChange('Ga'));
      },
      expect: () => [
        const SearchState.result(
          uiState: SearchUIState(
            input: 'G',
            foundGames: [],
          ),
        ),
        const SearchState.result(
          uiState: SearchUIState(input: 'Ga', foundGames: []),
        )
      ],
    );

    blocTest(
      'empty search returns uiState with error',
      build: () => SearchBloc(mockGameSearchRepository),
      act: (bloc) {
        bloc.add(const SearchEvent.search());
      },
      expect: () => [
        const SearchState.result(
          uiState: SearchUIState(
              input: '',
              foundGames: [],
              errorText: SearchUIState.missingInputError),
        ),
      ],
    );

    blocTest(
      'Input change to Game and Search, returns uiState with found games list',
      setUp: () {
        when(mockGameSearchRepository.searchGames('Game', any))
            .thenAnswer((_) async => searchedGames);
      },
      build: () => SearchBloc(mockGameSearchRepository),
      act: (bloc) {
        bloc.add(const SearchEvent.inputChange('Game'));
        bloc.add(const SearchEvent.search());
      },
      expect: () => [
        const SearchState.result(
            uiState: SearchUIState(input: 'Game', foundGames: [])),
        const SearchState.searching(
            uiState: SearchUIState(input: 'Game', foundGames: [])),
        SearchState.result(
            uiState: SearchUIState(input: 'Game', foundGames: searchedGames))
      ],
    );

    blocTest(
      'Search with GameFinderException, returns uiState with error message',
      setUp: () {
        when(mockGameSearchRepository.searchGames('Game', any)).thenAnswer(
            (_) async => throw AuthException(message: 'TestException'));
      },
      build: () => SearchBloc(mockGameSearchRepository),
      act: (bloc) {
        bloc.add(const SearchEvent.inputChange('Game'));
        bloc.add(const SearchEvent.search());
      },
      expect: () => [
        const SearchState.result(
          uiState: SearchUIState(input: 'Game', foundGames: []),
        ),
        const SearchState.searching(
          uiState: SearchUIState(input: 'Game', foundGames: []),
        ),
        const SearchState.result(
          uiState: SearchUIState(
              input: 'Game', foundGames: [], errorText: 'TestException'),
        )
      ],
    );

    blocTest(
      'Set game favorite, returns uiState with game set favorite',
      build: () => SearchBloc(mockGameSearchRepository),
      setUp: () {
        when(mockGameSearchRepository.searchGames('Game', any))
            .thenAnswer((_) async => searchedGames);
      },
      act: (bloc) {
        bloc.add(const SearchEvent.inputChange('Game'));
        bloc.add(const SearchEvent.search());
        bloc.add(const SearchEvent.setFavorite(1234, true));
      },
      expect: () => [
        const SearchState.result(
          uiState: SearchUIState(input: 'Game', foundGames: []),
        ),
        const SearchState.searching(
          uiState: SearchUIState(input: 'Game', foundGames: []),
        ),
        SearchState.result(
          uiState: SearchUIState(
            input: 'Game',
            foundGames: searchedGames,
          ),
        ),
        SearchState.result(
          uiState: SearchUIState(
            input: 'Game',
            foundGames:
                searchedGames.map((e) => e.copyWith(isFavorite: true)).toList(),
          ),
        )
      ],
    );

    tearDown(() async {
      await Hive.deleteFromDisk();
    });
  });
}
