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

    if (controller.isFullScreen) {
      // Force landscape orientation for fullscreen
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      // Force portrait
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
      // Set preferred orientation to device default
      // Empty list causes the application to defer to the operating system default.
      // See: https://api.flutter.dev/flutter/services/SystemChrome/setPreferredOrientations.html
      SystemChrome.setPreferredOrientations([]);
    }

    return SizedBox(
      height:
          controller.isFullScreen ? MediaQuery.of(context).size.height : 250,
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
