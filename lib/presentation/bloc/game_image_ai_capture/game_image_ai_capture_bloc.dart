import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_image_capture_event.dart';
part 'game_image_capture_state.dart';
part 'game_image_capture_bloc.freezed.dart';

class GameImageCaptureBloc extends Bloc<GameImageCaptureEvent, GameImageCaptureState> {
  GameImageCaptureBloc() : super(const GameImageCaptureState.initial()) {
    on<_ImageCapture>((event, emit) {
      // TODO: implement event handler
    });
  }
}
