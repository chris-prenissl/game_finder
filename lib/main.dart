import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:game_finder/constants/numbers.dart';
import 'package:game_finder/data/repository/auth_repository.dart';
import 'package:game_finder/data/repository/favorite_repository.dart';
import 'package:game_finder/data/repository/game_search_repository.dart';
import 'package:game_finder/data/repository/gemini_ai_repository.dart';
import 'package:game_finder/data/repository/repository_constants.dart';
import 'package:game_finder/presentation/bloc/search/search_bloc.dart';
import 'package:game_finder/presentation/router.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'constants/colors.dart';
import 'constants/strings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: Strings.dotEnvFileName);
  await Hive.initFlutter();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final clientId = dotenv.env[Strings.clientIdDotEnvKey];
    final clientSecret = dotenv.env[Strings.clientSecretDotEnvKey];
    final geminiApiKey = dotenv.env[Strings.geminiApiDotEnvKey];
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepository(
              clientId: clientId!,
              clientSecret: clientSecret!,
              tokenRequestToleranceInSeconds:
                  Numbers.tokenRefreshToleranceDuration),
        ),
        RepositoryProvider(
          create: (context) => FavoriteRepository(),
        ),
        RepositoryProvider(create: (context) {
          final geminiModel = GenerativeModel(
              model: RepositoryConstants.geminiModel, apiKey: geminiApiKey!);
          return GeminiAiRepository(generativeModel: geminiModel);
        })
      ],
      child: RepositoryProvider<GameSearchRepository>(
        create: (context) => GameSearchRepository(
            authRepository: context.read<AuthRepository>(),
            favoriteRepository: context.read<FavoriteRepository>(),
            clientId: clientId!),
        child: BlocProvider<SearchBloc>(
          create: (context) => SearchBloc(context.read<GameSearchRepository>()),
          child: MaterialApp.router(
            theme: ThemeData.from(
                colorScheme:
                    ColorScheme.fromSeed(seedColor: ColorConstants.seedColor)),
            routerConfig: router,
          ),
        ),
      ),
    );
  }
}
