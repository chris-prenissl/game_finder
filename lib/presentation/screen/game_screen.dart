import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../domain/model/game.dart';
import '../constants/numbers.dart';
import '../constants/strings.dart';

class GameScreen extends StatelessWidget {
  final Game _game;

  const GameScreen(
    this._game, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final coverUrl = _game.coverImgUrl;
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Column(
            children: [
              Text(
                _game.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(_game.genres.join(Strings.commaSeparator)),
            ],
          ),
        ),
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
                _game.summary ?? '',
                style: const TextStyle(fontSize: Numbers.gameSummaryFontSize),
              ),
              const SizedBox(height: Numbers.bigPadding),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _game.screenShotUrls
                      .map((url) => Padding(
                            padding:
                                const EdgeInsets.all(Numbers.standardPadding),
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
  }
}
