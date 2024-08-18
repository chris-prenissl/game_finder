import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:game_finder/data/exception/game_image_ai_capture_exception.dart';
import 'package:game_finder/data/repository/gemini_ai_repository.dart';

part 'game_image_ai_capture_event.dart';

part 'game_image_ai_capture_state.dart';

part 'game_image_ai_capture_bloc.freezed.dart';

class GameImageAiCaptureBloc
    extends Bloc<GameImageAiCaptureEvent, GameImageAiCaptureState> {
  final GeminiAiRepository _aiRepository;
  final Future<List<CameraDescription>> Function() _getCameras;

  GameImageAiCaptureBloc(this._aiRepository, this._getCameras)
      : super(const GameImageAiCaptureState.loading()) {
    on<_CameraSearch>((event, emit) async {
      try {
        final cameras = await _getCameras();
        emit(GameImageAiCaptureState.initialized(cameras.first));
      } catch (e) {
        if (e is CameraException) {
          emit(GameImageAiCaptureState.error(
              e.description ?? GameImageAiCaptureException.cameraError));
        } else {
          rethrow;
        }
      }
    });
    on<_ImageCapture>((event, emit) async {
      emit(const GameImageAiCaptureState.loading());

      try {
        final result = await _aiRepository.getGameNameByImage(event.image);
        emit(GameImageAiCaptureState.aiResult(result));
      } catch (e) {
        if (e is IOException) {
          emit(const GameImageAiCaptureState.error(GameImageAiCaptureException.aiError));
        } else {
          rethrow;
        }
      }
    });
  }
}
