import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_finder/presentation/bloc/game_image_ai_capture/game_image_ai_capture_bloc.dart';
import 'package:go_router/go_router.dart';

class GameImageAiCaptureScreen extends StatefulWidget {
  const GameImageAiCaptureScreen({super.key});

  @override
  State<GameImageAiCaptureScreen> createState() =>
      _GameImageAiCaptureScreenState();
}

class _GameImageAiCaptureScreenState extends State<GameImageAiCaptureScreen> {
  CameraController? _controller;

  @override
  void initState() {
    super.initState();
    context
        .read<GameImageAiCaptureBloc>()
        .add(const GameImageAiCaptureEvent.cameraSearch());
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<GameImageAiCaptureBloc>();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Capture game content to search for the game'),
        ),
        body: BlocConsumer<GameImageAiCaptureBloc, GameImageAiCaptureState>(
          listener: (context, state) {
            state.when(
              loading: () {},
              initialized: (camera) {
                _controller = CameraController(camera, ResolutionPreset.medium);
                _controller!.initialize().then((_) {
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
              aiResult: (gameTitle) {
                context.pop(gameTitle);
              },
              error: (_) {},
            );
          },
          builder: (context, state) {
            return state.when(
                initialized: (_) =>
                    Center(
                      child: _controller != null
                          ? CameraPreview(_controller!)
                          : const CircularProgressIndicator(),
                    ),
                aiResult: (_) =>
                const Center(
                  child: CircularProgressIndicator(),
                ),
                loading: () =>
                const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (message) =>
                    Center(
                      child: Text(
                        message,
                        style: const TextStyle(color: Colors.red),
                      ),
                    )
            );
          },
        ),
        floatingActionButton: _controller != null ? FloatingActionButton(
          onPressed: () async {
            final image = await _captureImage();
            bloc.add(GameImageAiCaptureEvent.imageCapture(image));
          },
          child: const Icon(Icons.camera_alt),
        ) : null
    );
  }

  Future<Uint8List> _captureImage() async {
    final image = await _controller!.takePicture();
    final imageBytes = await image.readAsBytes();
    return imageBytes;
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  static const _cameraAccessDeniedErrorCode = 'CameraAccessDenied';
}
