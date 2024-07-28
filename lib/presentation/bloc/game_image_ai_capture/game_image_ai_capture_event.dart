part of 'game_image_capture_bloc.dart';

@freezed
class GameImageCaptureEvent with _$GameImageCaptureEvent {
  const factory GameImageCaptureEvent.cameraFind() = _CameraFind;
  const factory GameImageCaptureEvent.imageCapture(Uint8List image) = _ImageCapture;
  const factory GameImageCaptureEvent.cancel() = _Cancel;
}
