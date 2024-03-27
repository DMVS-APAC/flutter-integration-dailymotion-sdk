// ignore: file_names
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterdailymotion/DailymotionPlayer/DailymotionPlayerController.dart';

class DailymotionPlayerWidget extends StatelessWidget {
  final DailymotionPlayerController controller;

  const DailymotionPlayerWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
// This is used in the platform side to register the view.
    const String viewType = 'dailymotion-player-view';

    return SizedBox(
      height: 250,
      child: UiKitView(
        key: super.key,
        viewType: viewType,
        layoutDirection: TextDirection.ltr,
        creationParams: {
          "videoId": controller.videoId,
          "playerId": controller.playerId,
        },
        creationParamsCodec: const StandardMessageCodec(),
      ),
    );
  }
}
