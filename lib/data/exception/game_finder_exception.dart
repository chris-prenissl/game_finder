import 'dart:io';

abstract class GameFinderException extends IOException {
  final String message;

  GameFinderException({required this.message});
}