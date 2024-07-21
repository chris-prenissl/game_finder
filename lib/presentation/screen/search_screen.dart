import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_finder/presentation/bloc/search/search_bloc.dart';
import 'package:game_finder/presentation/router.dart';
import 'package:go_router/go_router.dart';

import '../constants/strings.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.appTitle),
      ),
      body: BlocConsumer<SearchBloc, SearchState>(
        listener: (context, state) {
          if (state.uiState.selectedGame != null) {
            context.push(Routes.base + Routes.gamePath);
          }
        },
        builder: (context, state) {
          return state.when(
            searching: (_) => const Center(
              child: CircularProgressIndicator(),
            ),
            result: (uiState) {
              final bloc = context.read<SearchBloc>();
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: Strings.searchHint,
                            labelText: Strings.searchLabelText,
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (input) =>
                              bloc.add(SearchEvent.inputChange(input)),
                          onSubmitted: (_) =>
                              bloc.add(const SearchEvent.search()),
                        ),
                      ),
                      FilledButton(
                        onPressed: () => bloc.add(const SearchEvent.search()),
                        child: const Text(Strings.searchButtonLabelText),
                      )
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: uiState.foundGames.length,
                        itemBuilder: (context, index) {
                          final game = uiState.foundGames[index];
                      return GestureDetector(
                        onTap: () => bloc.add(SearchEvent.selectGame(game)),
                        child: Card(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(game.name, style: const TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                            Text(game.genres.join(", "),)
                          ],
                        )),
                      );
                    }),
                  )
                ],
              );
            },
            error: (_) => const Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}
