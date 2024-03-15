// ignore: file_names
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class VideoPlayerWidget extends StatelessWidget {
  final String videoId;
  final String playerId;

  const VideoPlayerWidget(
      {super.key, required this.videoId, required this.playerId});

  @override
  Widget build(BuildContext context) {
// This is used in the platform side to register the view.
    const String viewType = '<platform-view-type>';
    // Pass parameters to the platform side.
    final Map<String, dynamic> creationParams = <String, dynamic>{};

    return Column(
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Container(
            alignment: Alignment.topRight,
            color: Colors.grey,
            child: Container(
              alignment: Alignment.center,
              child: UiKitView(
                viewType: viewType,
                layoutDirection: TextDirection.ltr,
                creationParams: creationParams,
                creationParamsCodec: const StandardMessageCodec(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
