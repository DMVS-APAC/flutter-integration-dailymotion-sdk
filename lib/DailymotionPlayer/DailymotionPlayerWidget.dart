// ignore: file_names
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterdailymotion/DailymotionPlayer/DailymotionPlayerController.dart';
import 'dart:io' show Platform;

class DailymotionPlayerWidget extends StatelessWidget {
  // ignore: slash_for_doc_comments
  /**
   *  initiate DailymotionPlayerController
   * */
  final DailymotionPlayerController controller;

  const DailymotionPlayerWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    /**
     * the plugin view type
     */
    const String viewType = 'dailymotion-player-view';

    return SizedBox(
      height: 250,
      child: Platform.isAndroid
          ?
          /**
           * show AndroidView if it's androi
           */
          AndroidView(
              viewType: viewType,
              layoutDirection: TextDirection.ltr,
              creationParams: {
                "videoId": controller.videoId,
                "playerId": controller.playerId,
              },
              creationParamsCodec: const StandardMessageCodec(),
            )
          :
          /**
           * Show UiKitView if it's iOS
           */
          UiKitView(
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
