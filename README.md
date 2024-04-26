# Flutter - Dailymotion SDK Integration

This documentation provides guidelines for integrating the Dailymotion iOS SDK into a Flutter application. By following these steps, you will be able to create a Dailymotion player in your Flutter app and control it using Flutter code.

# **Requirements:**

- Flutter SDK is installed on your development machine.
- Xcode installed for iOS development.
- Dailymotion iOS SDK.
- Basic knowledge of Flutter and iOS development.

# **Integration Steps:**

## **Step 1: Create DailymotionPlayer Folder:**

Create a new folder named `DailymotionPlayer` in your Flutter project's directory.

## **Step 2: Create DailymotionPlayerController.dart:**

Inside the **`DailymotionPlayer`** folder, create a new Dart file named **`DailymotionPlayerController.dart`**. Copy and paste the following code into the file:

```dart
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

```

## **Step 3: Create DailymotionPlayerWidget.dart:**

Inside the `DailymotionPlayer` folder, create another Dart file named `DailymotionPlayerWidget.dart` Copy and paste the following code into the file:

```dart
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

```

## **Step 4. Create Files Inside iOS Project**

1.  Open `/ios/Runner.xcodeproj` in Xcode.
2.  Install DailymotionSDK in your project https://github.com/dailymotion/player-sdk-ios
3.  Navigate to the `Runner` folder.
4.  Create a group named `DailymotionPlayer`.
5.  Inside the `DailymotionPlayer` group, create the following files:
    a. `DailymotionPlayerPlugin.swift`
    b. `DailymotionPlayerController.swift`
    c. `DailymotionPlayerViewFactory.swift`
        You can check all the code for `DailymotionPlayer` implementation in [here](https://github.com/DMVS-APAC/flutter-integration-ios-sdk/tree/main/ios/Runner/DailymotionPlayer)

## **Step 5: Modify AppDelegate.swift**

In the **`AppDelegate.swift`** file, perform the following modifications:

1. Import the necessary frameworks.
2. Configure Dailymotion SDK initialisation.
3. Handle necessary configurations for Dailymotion SDK integration.

```swift
import Flutter
import UIKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)

        weak var registrar = self.registrar(forPlugin: "dailymotion-player-plugin")

        let factory = DailymotionPlayerViewFactory(messenger: registrar!.messenger())
        self.registrar(forPlugin: "<dailymotion-player-plugin>")!.register(
            factory,
            withId: "dailymotion-player-view"
        )

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
```

## **Usage:**

To use the `DailymotionPlayerWidget` in your Flutter app, simply instantiate a `DailymotionPlayerController` with the required parameters (videoId and playerId) and pass it to the `DailymotionPlayerWidget` , example:

```dart
import 'package:flutter/material.dart';
import 'package:flutterdailymotion/DailymotionPlayer/DailymotionPlayerController.dart';
import 'package:flutterdailymotion/DailymotionPlayer/DailymotionPlayerWidget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late DailymotionPlayerController dmController;

  @override
  void initState() {
    super.initState();

    dmController =
        DailymotionPlayerController(videoId: "x8q4e1z", playerId: "xqzrc");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            Column(
              children: [

                DailymotionPlayerWidget(controller: dmController),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PlayButton(onPressed: () => {dmController.play()}),
                    PauseButton(onPressed: () => dmController.pause()),
                    ElevatedButton(
                      onPressed: () {
                        dmController.load('x8o3icz');
                      },
                      child: const Text(
                        'Load x8o3icz',
                      ),
                    )
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class PlayButton extends StatelessWidget {
  final VoidCallback onPressed;

  const PlayButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.play_arrow),
      // iconSize: 64.0,
      onPressed: onPressed,
    );
  }
}

class PauseButton extends StatelessWidget {
  final VoidCallback onPressed;

  const PauseButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.pause),
      // iconSize: 64.0,
      onPressed: onPressed,
    );
  }
}

```
