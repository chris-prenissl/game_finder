import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_finder/constants/strings.dart';
import 'package:game_finder/domain/model/game.dart';
import 'package:game_finder/presentation/bloc/search/search_bloc.dart';
import 'package:game_finder/presentation/bloc/search/search_ui_state.dart';
import 'package:game_finder/presentation/component/game_list_card.dart';
import 'package:game_finder/presentation/screen/search_screen.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'search_screen_test.mocks.dart';

@GenerateNiceMocks([MockSpec<SearchBloc>()])
void main() {
  group('SearchScreen', () {
    late List<Game> foundGames = [
      const Game(
        id: 1234,
        name: 'Game',
        summary: 'Summary',
        genres: ['Genre1', 'Genre2'],
        coverImgUrl: 'CoverImgUrl',
        screenShotUrls: ['ScreenshotUrl1', 'ScreenshotUrl2'],
        isFavorite: false,
      ),
      const Game(
        id: 1234,
        name: 'Game2',
        summary: 'Summary2',
        genres: ['Genre21', 'Genre22'],
        coverImgUrl: 'CoverImgUrl2',
        screenShotUrls: ['ScreenshotUrl21', 'ScreenshotUrl22'],
        isFavorite: true,
      )
    ];

    testWidgets('initial screen', (WidgetTester tester) async {
      await tester.pumpWidget(
        BlocProvider<SearchBloc>(
          create: (BuildContext context) {
            final mockBloc = MockSearchBloc();
            when(mockBloc.state).thenReturn(
              const SearchState.result(
                uiState: SearchUIState(
                  input: '',
                  foundGames: [],
                ),
              ),
            );
            return mockBloc;
          },
          child: MaterialApp(
            home: SearchScreen(),
          ),
        ),
      );

      expect(find.text(Strings.appTitle), findsOneWidget);
      expect(find.text(Strings.searchButtonLabelText), findsOneWidget);

      final noInputFinder = find.byWidgetPredicate(
          (widget) => widget is TextField && widget.controller!.text.isEmpty);
      expect(noInputFinder, findsOneWidget);
    });

    testWidgets('changed input', (WidgetTester tester) async {
      await tester.pumpWidget(
        BlocProvider<SearchBloc>(
          create: (BuildContext context) {
            final mockBloc = MockSearchBloc();
            when(mockBloc.state).thenReturn(
              const SearchState.result(
                uiState: SearchUIState(
                  input: 'Test',
                  foundGames: [],
                ),
              ),
            );
            return mockBloc;
          },
          child: MaterialApp(
            home: SearchScreen(),
          ),
        ),
      );

      final noInputFinder = find.byWidgetPredicate(
              (widget) => widget is TextField && widget.controller!.text == 'Test');
      expect(noInputFinder, findsOneWidget);
    });

    testWidgets('is loading', (WidgetTester tester) async {
      await tester.pumpWidget(
        BlocProvider<SearchBloc>(
          create: (BuildContext context) {
            final mockBloc = MockSearchBloc();
            when(mockBloc.state).thenReturn(
              const SearchState.searching(
                uiState: SearchUIState(
                  input: '',
                  foundGames: [],
                ),
              ),
            );
            return mockBloc;
          },
          child: MaterialApp(
            home: SearchScreen(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('found games', (WidgetTester tester) async {
      await tester.pumpWidget(
        BlocProvider<SearchBloc>(
          create: (BuildContext context) {
            final mockBloc = MockSearchBloc();
            when(mockBloc.state).thenReturn(
              SearchState.result(
                uiState: SearchUIState(input: '', foundGames: foundGames),
              ),
            );
            return mockBloc;
          },
          child: MaterialApp(
            home: SearchScreen(),
          ),
        ),
      );


      expect(find.byType(GameListCard), findsExactly(2));
      expect(find.text(foundGames.first.name), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsOneWidget);
      expect(find.text(foundGames[1].name), findsOneWidget);
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    });

    testWidgets('error display', (WidgetTester tester) async {
      await tester.pumpWidget(
        BlocProvider<SearchBloc>(
          create: (BuildContext context) {
            final mockBloc = MockSearchBloc();
            when(mockBloc.state).thenReturn(
              SearchState.result(
                uiState: SearchUIState(input: '', foundGames: foundGames, errorText: 'ErrorText'),
              ),
            );
            return mockBloc;
          },
          child: MaterialApp(
            home: SearchScreen(),
          ),
        ),
      );


      final errorInputFinder = find.byWidgetPredicate((widget) => widget is TextField && widget.decoration!.errorText == 'ErrorText');
      expect(errorInputFinder, findsOneWidget);

    });
  });
}
