import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_finder/presentation/bloc/search/search_bloc.dart';
import 'package:game_finder/presentation/component/game_list_card.dart';
import 'package:game_finder/presentation/router.dart';
import 'package:go_router/go_router.dart';

import '../../constants/numbers.dart';
import '../../constants/strings.dart';

class SearchScreen extends StatelessWidget {
  final textEditingController = TextEditingController();

  SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        textEditingController.text = state.uiState.input;
        final appBar = AppBar(
          title: const Text(Strings.appTitle),
        );
        return state.when(
          searching: (_) => Scaffold(
            appBar: appBar,
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
          result: (uiState) {
            final bloc = context.read<SearchBloc>();
            return Scaffold(
              appBar: appBar,
              body: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsets.all(Numbers.standardPadding),
                          child: TextField(
                            controller: textEditingController,
                            decoration: InputDecoration(
                              hintText: Strings.searchHint,
                              labelText: Strings.searchLabelText,
                              border: const OutlineInputBorder(),
                              errorText: uiState.errorText,
                              suffixIcon: uiState.input.isNotEmpty
                                  ? IconButton(
                                      onPressed: () => bloc.add(
                                        const SearchEvent.inputChange(''),
                                      ),
                                      icon: const Icon(Icons.cancel),
                                    )
                                  : null,
                            ),
                            onChanged: (input) =>
                                bloc.add(SearchEvent.inputChange(input)),
                            onSubmitted: (_) =>
                                bloc.add(const SearchEvent.search()),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(Numbers.standardPadding),
                        child: FilledButton(
                          onPressed: () => bloc.add(const SearchEvent.search()),
                          child: const Text(Strings.searchButtonLabelText),
                        ),
                      )
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: uiState.foundGames.length,
                      itemBuilder: (context, index) {
                        final game = uiState.foundGames[index];
                        return GestureDetector(
                          onTap: () async {
                            final bloc = context.read<SearchBloc>();
                            bool? isFavorite = await context.push(
                                Routes.base + Routes.gamePath,
                                extra: game);
                            if (isFavorite != null) {
                              bloc.add(
                                  SearchEvent.setFavorite(game.id, isFavorite));
                            }
                          },
                          child: GameListCard(game),
                        );
                      },
                    ),
                  )
                ],
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () async {
                  final String? result =
                      await context.push(Routes.base + Routes.aiImageCapture);
                  if (result != null) {
                    textEditingController.text = result;
                    bloc.add(SearchEvent.aiSearch(result));
                  }
                },
                label: const Text(Strings.aiSearchButtonLabel),
                icon: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.camera_alt_outlined),
                    Icon(Icons.auto_awesome),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
