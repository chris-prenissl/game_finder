import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_finder/presentation/bloc/game_image_ai_capture/game_image_ai_capture_bloc.dart';

import '../../constants/strings.dart';

class GameImageAiCaptureScreen extends StatefulWidget {
  const GameImageAiCaptureScreen({super.key});

  @override
  State<GameImageAiCaptureScreen> createState() =>
      _GameImageAiCaptureScreenState();
}

class _GameImageAiCaptureScreenState extends State<GameImageAiCaptureScreen> {
  late CameraController _controller;

  @override
  void initState() {
    super.initState();
    context
        .read<GameImageAiCaptureBloc>()
        .add(const GameImageAiCaptureEvent.cameraSearch());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(Strings.appTitle),
        ),
        body: BlocConsumer<GameImageAiCaptureBloc, GameImageAiCaptureState>(
          listener: (context, state) {
            state.when(
              loading: () {},
              initialized: (camera) {
                _controller = CameraController(camera, ResolutionPreset.medium);
                _controller.initialize().then((_) {
                  if (!mounted) {
                    return;
                  }
                  setState(() {});
                }).catchError((Object e) {
                  if (e is CameraException) {
                    switch (e.code) {
                      case _cameraAccessDeniedErrorCode:
                        // Handle access errors here.
                        break;
                      default:
                        // Handle other errors here.
                        break;
                    }
                  }
                });
              },
              aiResult: (gameTitle) {},
              error: (_) {},
            );
          },
          builder: (context, state) {
            state.when(
              initialized: (camera) => CameraPreview(
                CameraController(camera, ResolutionPreset.medium),
              ),
              aiResult: (_) => {},
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (message) => Scaffold(
                body: Center(
                  child: Text(
                    message,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
                floatingActionButton:
                    FloatingActionButton(onPressed: () => context.read),
              ),
            );
            return const CircularProgressIndicator();
          },
        ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  static const _cameraAccessDeniedErrorCode = 'CameraAccessDenied';
}
