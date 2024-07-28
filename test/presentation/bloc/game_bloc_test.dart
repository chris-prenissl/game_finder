import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_finder/data/repository/favorite_repository.dart';
import 'package:game_finder/domain/model/game.dart';
import 'package:game_finder/presentation/bloc/game/game_bloc.dart';
import 'package:hive/hive.dart';

void main() {
  group('GameBloc', () {
    late Game game;
    late FavoriteRepository favoriteRepository;

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
    });

    test('initial state', () {
      final gameBloc = GameBloc(game, favoriteRepository);
      final result = gameBloc.state;

      expect(result.game, equals(game));
    });

    blocTest(
      'toggleFavorite, first call returns game with favorite true',
      build: () => GameBloc(game, favoriteRepository),
      act: (bloc) {
        bloc.add(const GameEvent.toggleFavorite());
        bloc.add(const GameEvent.toggleFavorite());
      },
      wait: const Duration(milliseconds: 400),
      expect: () => [
        GameState.baseState(game.copyWith(isFavorite: true)),
        GameState.baseState(game.copyWith(isFavorite: false))
      ],
    );
  });
}
