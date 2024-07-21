import 'package:flutter/material.dart';

import '../../domain/model/game.dart';
import '../constants/numbers.dart';
import '../constants/strings.dart';

class GameListCard extends StatelessWidget {
  final Game _game;

  const GameListCard(this._game, {super.key});

  @override
  Widget build(BuildContext context) {
    final coverImageUrl = _game.coverImgUrl;
    final genres = _game.genres;
    return SizedBox(
      height: Numbers.gameCardHeight,
      child: Card(
        child: Row(
          children: [
            if (coverImageUrl != null)
              Padding(
                  padding: const EdgeInsets.all(Numbers.standardPadding),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(Numbers.standardBorderRadius),
                      child: Image.network(height: Numbers.gameCardHeight, coverImageUrl),),),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _game.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  if (genres.isNotEmpty)
                  Text(
                    '${Strings.genreTitle}: ${genres.join(Strings.commaSeparator)}',
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
