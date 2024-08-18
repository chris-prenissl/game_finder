import 'dart:io';
import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_finder/data/exception/game_image_ai_capture_exception.dart';
import 'package:game_finder/data/repository/gemini_ai_repository.dart';
import 'package:game_finder/presentation/bloc/game_image_ai_capture/game_image_ai_capture_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'game_image_ai_capture_test.mocks.dart';

@GenerateNiceMocks(
    [MockSpec<GeminiAiRepository>(), MockSpec<CameraDescription>(), MockSpec<IOException>()])
void main() {
  late GeminiAiRepository mockGeminiAiRepository;

  late Uint8List mockImage;
  late CameraDescription mockCameraDescription1;
  late CameraDescription mockCameraDescription2;

  group('GameImageAiCaptureBloc', () {
    setUpAll(() {
      mockImage = Uint8List(0);
      mockGeminiAiRepository = MockGeminiAiRepository();
      mockCameraDescription1 = MockCameraDescription();
      when(mockCameraDescription1.name).thenReturn('Mock Camera 1');
      mockCameraDescription2 = MockCameraDescription();
      when(mockCameraDescription1.name).thenReturn('Mock Camera 2');
    });

    blocTest('cameraSearch with first camera found, emits first camera',
        build: () {
          when(mockGeminiAiRepository.getGameNameByImage(mockImage))
              .thenAnswer((_) => Future(() => 'Game Image Title'));
          return GameImageAiCaptureBloc(
              mockGeminiAiRepository,
              () => Future(() => <CameraDescription>[
                    mockCameraDescription1,
                    mockCameraDescription2
                  ]));
        },
        act: (bloc) => bloc.add(const GameImageAiCaptureEvent.cameraSearch()),
        expect: () =>
            [GameImageAiCaptureState.initialized(mockCameraDescription1)]);

    blocTest('cameraSearch with CameraException, emits error description',
        build: () {
          when(mockGeminiAiRepository.getGameNameByImage(mockImage))
              .thenAnswer((_) => Future(() => 'Game Image Title'));
          return GameImageAiCaptureBloc(
            mockGeminiAiRepository,
            () => throw CameraException('', null),
          );
        },
        act: (bloc) => bloc.add(const GameImageAiCaptureEvent.cameraSearch()),
        expect: () => [
              const GameImageAiCaptureState.error(
                  GameImageAiCaptureException.cameraError)
            ]);

    blocTest(
      'cameraSearch with other Exception than CameraException, rethrows Exception',
      build: () {
        when(mockGeminiAiRepository.getGameNameByImage(mockImage))
            .thenAnswer((_) => Future(() => 'Game Image Title'));
        return GameImageAiCaptureBloc(
          mockGeminiAiRepository,
          () => throw Exception(),
        );
      },
      act: (bloc) => bloc.add(const GameImageAiCaptureEvent.cameraSearch()),
      errors: () => [isA<Exception>()],
    );

    blocTest(
      'imageCapture with result, emits result',
      build: () {
        when(mockGeminiAiRepository.getGameNameByImage(mockImage))
            .thenAnswer((_) => Future(() => 'Game Image Title'));
        return GameImageAiCaptureBloc(
          mockGeminiAiRepository,
          () => Future(() => <CameraDescription>[mockCameraDescription1]),
        );
      },
      act: (bloc) => bloc.add(GameImageAiCaptureEvent.imageCapture(mockImage)),
      expect: () => [
        const GameImageAiCaptureState.loading(),
        const GameImageAiCaptureState.aiResult('Game Image Title')
      ],
    );

    blocTest(
      'imageCapture with not IOException, emits error',
      build: () {
        when(mockGeminiAiRepository.getGameNameByImage(mockImage)).thenAnswer(
          (_) => Future(() =>
              throw NetworkImageLoadException(statusCode: 10, uri: Uri())),
        );
        return GameImageAiCaptureBloc(mockGeminiAiRepository,
            () => Future(() => <CameraDescription>[mockCameraDescription1]));
      },
      act: (bloc) => bloc.add(GameImageAiCaptureEvent.imageCapture(mockImage)),
      expect: () => [
        const GameImageAiCaptureState.loading(),
      ],
      errors: () => [isA<NetworkImageLoadException>()]
    );

    blocTest(
        'imageCapture with IOException, emits error',
        build: () {
          when(mockGeminiAiRepository.getGameNameByImage(mockImage)).thenAnswer(
                (_) => Future(() =>
            throw MockIOException()),
          );
          return GameImageAiCaptureBloc(mockGeminiAiRepository,
                  () => Future(() => <CameraDescription>[mockCameraDescription1]));
        },
        act: (bloc) => bloc.add(GameImageAiCaptureEvent.imageCapture(mockImage)),
        expect: () => [
          const GameImageAiCaptureState.loading(),
          const GameImageAiCaptureState.error(GameImageAiCaptureException.aiError)
        ]
    );
  });
}
