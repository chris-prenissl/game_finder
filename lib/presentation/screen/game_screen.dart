import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/numbers.dart';
import '../../constants/strings.dart';
import '../bloc/game/game_bloc.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        final game = state.game;
        final coverUrl = game.coverImgUrl;
        return Scaffold(
          appBar: AppBar(
            title: Center(
              child: Column(
                children: [
                  Text(
                    game.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(game.genres.join(Strings.commaSeparator)),
                ],
              ),
            ),
            actions: [
              IconButton(
                onPressed: () => context
                    .read<GameBloc>()
                    .add(const GameEvent.toggleFavorite()),
                icon: Icon(
                    game.isFavorite ? Icons.favorite : Icons.favorite_border),
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(Numbers.bigPadding),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  if (coverUrl != null)
                    Padding(
                      padding: const EdgeInsets.all(Numbers.standardPadding),
                      child: Image.network(coverUrl),
                    ),
                  Text(
                    game.summary ?? '',
                    style:
                        const TextStyle(fontSize: Numbers.gameSummaryFontSize),
                  ),
                  const SizedBox(height: Numbers.bigPadding),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: game.screenShotUrls
                          .map((url) => Padding(
                                padding: const EdgeInsets.all(
                                    Numbers.standardPadding),
                                child: Image.network(url),
                              ))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
