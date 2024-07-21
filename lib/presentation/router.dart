import 'package:flutter/cupertino.dart';
import 'package:game_finder/presentation/screen/game_screen.dart';
import 'package:game_finder/presentation/screen/search_screen.dart';
import 'package:go_router/go_router.dart';

import '../domain/model/game.dart';

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
            return GameScreen(game);
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