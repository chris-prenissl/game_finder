import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_finder/data/repository/favorite_repository.dart';
import 'package:game_finder/presentation/screen/game_screen.dart';
import 'package:game_finder/presentation/screen/search_screen.dart';
import 'package:go_router/go_router.dart';

import '../domain/model/game.dart';
import 'bloc/game/game_bloc.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: Routes.base,
      builder: (BuildContext context, GoRouterState state) {
        return SearchScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          path: Routes.gamePath,
          builder: (BuildContext context, GoRouterState state) {
            final game = state.extra as Game;
            return BlocProvider(
              create: (context) =>
                  GameBloc(game, context.read<FavoriteRepository>()),
              child: const GameScreen(),
            );
          },
        ),
      ],
    ),
  ],
);

class Routes {
  static const String base = '/';
  static const String gamePath = 'game';
}
