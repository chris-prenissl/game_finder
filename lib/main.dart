import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_finder/presentation/bloc/search/search_bloc.dart';
import 'package:game_finder/presentation/constants/strings.dart';
import 'package:game_finder/presentation/screen/search_screen.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchBloc>(
      create: (_) => SearchBloc(),
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text(Strings.appTitle),
          ),
          body: const SearchScreen(),
        ),
      ),
    );
  }
}
