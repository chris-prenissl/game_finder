import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_finder/constants/strings.dart';
import 'package:game_finder/domain/model/game.dart';
import 'package:game_finder/presentation/bloc/game/game_bloc.dart';
import 'package:game_finder/presentation/screen/game_screen.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'game_screen_test.mocks.dart';

@GenerateNiceMocks([MockSpec<GameBloc>()])
void main() {
  group('GameScreen', () {
    late Game game;

    setUp(() {
      game = const Game(
        id: 1234,
        name: 'Game',
        summary: 'Summary',
        genres: ['Genre1', 'Genre2'],
        coverImgUrl: 'CoverImgUrl',
        screenShotUrls: ['ScreenshotUrl1', 'ScreenshotUrl2'],
        isFavorite: false,
      );
    });

    testWidgets('initial state', (WidgetTester tester) async {
      await tester.pumpWidget(
        BlocProvider<GameBloc>(
          create: (BuildContext context) {
            final mockBloc = MockGameBloc();
            when(mockBloc.state).thenReturn(GameState.baseState(game));
            return mockBloc;
          },
          child: const MaterialApp(
            home: GameScreen(),
          ),
        ),
      );

      expect(find.text(game.name), findsOneWidget);
      expect(find.text(game.summary!), findsOneWidget);

      final genres = game.genres.join(Strings.commaSeparator);
      expect(find.text(genres), findsOneWidget);

      final coverImageFinder = find.byWidgetPredicate((widget) =>
          widget is Image &&
          widget.image is NetworkImage &&
          (widget.image as NetworkImage).url == game.coverImgUrl);
      expect(coverImageFinder, findsOneWidget);

      final firstScreenshotImageFinder = find.byWidgetPredicate((widget) =>
          widget is Image &&
          widget.image is NetworkImage &&
              (widget.image as NetworkImage).url == game.screenShotUrls[0]
      );
      expect(firstScreenshotImageFinder, findsOneWidget);

      final secondScreenshotImageFinder = find.byWidgetPredicate((widget) =>
      widget is Image &&
          widget.image is NetworkImage &&
          (widget.image as NetworkImage).url == game.screenShotUrls[1]
      );
      expect(secondScreenshotImageFinder, findsOneWidget);

      expect(find.byIcon(Icons.favorite_border), findsOneWidget);

      expect(find.text(game.id.toString()), findsNothing);
    });
  });
}
