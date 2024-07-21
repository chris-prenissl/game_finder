import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:game_finder/data/repository/auth_repository.dart';
import 'package:game_finder/data/repository/game_search_repository.dart';
import 'package:game_finder/presentation/bloc/search/search_bloc.dart';
import 'package:game_finder/presentation/router.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final clientId = dotenv.env['CLIENT_ID'];
    final clientSecret = dotenv.env['CLIENT_SECRET'];
    return RepositoryProvider<AuthRepository>(
      create: (context) => AuthRepository(
          clientId: clientId!,
          clientSecret: clientSecret!,
          tokenRequestToleranceInSeconds: 4),
      child: RepositoryProvider<GameSearchRepository>(
        create: (context) => GameSearchRepository(
            authRepository: context.read<AuthRepository>(),
            clientId: clientId!),
        child: BlocProvider<SearchBloc>(
          create: (context) => SearchBloc(context.read<GameSearchRepository>()),
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      ),
    );
  }
}
