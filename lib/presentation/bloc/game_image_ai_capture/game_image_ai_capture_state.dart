part of 'game_image_capture_bloc.dart';

@freezed
class GameImageCaptureState with _$GameImageCaptureState {
  const factory GameImageCaptureState.initial() = _Initial;
  const factory GameImageCaptureState.initialized() = _Initialized;
  const factory GameImageCaptureState.aiResult() = _AiResult;
  const factory GameImageCaptureState.error(String message) = _Error;
}
