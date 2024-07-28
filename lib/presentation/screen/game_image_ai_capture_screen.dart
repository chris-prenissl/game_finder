import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../constants/strings.dart';

class GameImageCaptureScreen extends StatefulWidget {

  const GameImageCaptureScreen({super.key});

  @override
  State<GameImageCaptureScreen> createState() => _GameImageCaptureScreenState();
}

class _GameImageCaptureScreenState extends State<GameImageCaptureScreen> {
  late CameraController _controller;

  @override
  void initState() {
    super.initState();
    //_controller = CameraController(, ResolutionPreset.max);
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
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isControllerInitialized = _controller.value.isInitialized;
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.appTitle),
      ),
      body: isControllerInitialized
          ? CameraPreview(_controller)
          : const CircularProgressIndicator(),
    );
  }

  static const _cameraAccessDeniedErrorCode = 'CameraAccessDenied';
}
