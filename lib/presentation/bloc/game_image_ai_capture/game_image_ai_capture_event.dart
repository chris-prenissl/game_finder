part of 'game_image_ai_capture_bloc.dart';

@freezed
class GameImageAiCaptureEvent with _$GameImageAiCaptureEvent {
  const factory GameImageAiCaptureEvent.cameraSearch() = _CameraSearch;
  const factory GameImageAiCaptureEvent.imageCapture(Uint8List image) = _ImageCapture;
}
