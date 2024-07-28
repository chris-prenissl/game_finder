part of 'game_image_ai_capture_bloc.dart';

@freezed
class GameImageAiCaptureState with _$GameImageAiCaptureState {
  const factory GameImageAiCaptureState.initialized(CameraDescription camera) = _Initialized;
  const factory GameImageAiCaptureState.aiResult(String gameTitle) = _AiResult;
  const factory GameImageAiCaptureState.loading() = _Loading;
  const factory GameImageAiCaptureState.error(String message) = _Error;
}
