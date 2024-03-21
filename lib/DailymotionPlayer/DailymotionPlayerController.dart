// ignore_for_file: file_names

import 'package:flutter/services.dart';

class DailymotionPlayerController {
  final String videoId;
  final String playerId;

  final MethodChannel _methodChannel =
      const MethodChannel('dailymotion-player-channel');

  DailymotionPlayerController({required this.videoId, required this.playerId});

  Future<void> play() async {
    try {
      await _methodChannel.invokeMethod('play');
    } on PlatformException catch (e) {
      print("Failed to play video: '${e.message}'.");
    }
  }

  Future<void> pause() async {
    try {
      await _methodChannel.invokeMethod('pause');
    } on PlatformException catch (e) {
      print("Failed to pause video: '${e.message}'.");
    }
  }

  Future<void> load(String videoId) async {
    try {
      await _methodChannel.invokeMethod('load', {'videoId': videoId});
    } on PlatformException catch (e) {
      print("Failed to load video: '${e.message}'.");
    }
  }
}
