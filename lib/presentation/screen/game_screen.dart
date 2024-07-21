import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/search/search_bloc.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        final game = state.uiState.selectedGame!;
        return Scaffold(
            appBar: AppBar(
              title: Text(game.name),
            ),
            body: Center(
              child: Text(game.name),
            ));
      },
    );
  }
}
