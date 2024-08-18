import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_finder/data/repository/favorite_repository.dart';
import 'package:game_finder/data/repository/gemini_ai_repository.dart';
import 'package:game_finder/domain/model/game.dart';
import 'package:game_finder/presentation/bloc/game/game_bloc.dart';
import 'package:hive/hive.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'game_bloc_test.mocks.dart';

@GenerateNiceMocks([MockSpec<FavoriteRepository>(), MockSpec<GeminiAiRepository>()])
void main() {
  group('GameBloc', () {
    late Game game;
    late FavoriteRepository favoriteRepository;
    late MockGeminiAiRepository mockGeminiAiRepository;

    setUp(() {
      Hive.init(
          '${Directory.current.path}/test/presentation/bloc/hive_game_bloc');
      game = const Game(
        id: 1234,
        name: 'Game',
        summary: null,
        genres: [],
        coverImgUrl: null,
        screenShotUrls: [],
        isFavorite: false,
      );
      favoriteRepository = FavoriteRepository();
      mockGeminiAiRepository = MockGeminiAiRepository();
    });

    test('initial state', () {
      final gameBloc =
          GameBloc(game, favoriteRepository, mockGeminiAiRepository);
      final result = gameBloc.state;

      expect(result.game, equals(game));
    });

    blocTest(
      'toggleFavorite, first call returns game with favorite true',
      build: () => GameBloc(game, favoriteRepository, mockGeminiAiRepository),
      act: (bloc) {
        bloc.add(const GameEvent.toggleFavorite());
        bloc.add(const GameEvent.toggleFavorite());
      },
      wait: const Duration(milliseconds: 400),
      expect: () => [
        GameState.result(game.copyWith(isFavorite: true)),
        GameState.result(game.copyWith(isFavorite: false))
      ],
    );

    blocTest(
      'requestAiDescription',
      build: () {
        when(mockGeminiAiRepository.getDescriptionOfGame(any))
            .thenAnswer((_) => Stream.fromIterable(['A', 'Game']));
        return GameBloc(game, MockFavoriteRepository(), mockGeminiAiRepository);
      },
      act: (bloc) {
        bloc.add(const GameEvent.requestAiDescription());
      },
      expect: () => [
        GameState.loading(game),
        GameState.partialAiResponse(game.copyWith(aiDescription: 'A')),
        GameState.partialAiResponse(game.copyWith(aiDescription: 'AGame')),
        GameState.result(game.copyWith(aiDescription: 'AGame'))
      ]
    );
    tearDown(() async {
      await Hive.deleteFromDisk();
    });
  });
}
