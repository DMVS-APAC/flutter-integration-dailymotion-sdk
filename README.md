# Flutter - Dailymotion SDK Integration

This documentation provides guidelines for integrating the Dailymotion iOS SDK & Dailymotion Android SDK into a Flutter application. By following these steps, you will be able to create a Dailymotion player in your Flutter app and control it using Flutter code.

- [Flutter - Dailymotion SDK Integration](#flutter---dailymotion-sdk-integration)
- [**Requirements:**](#--requirements---)
- [**iOS Integration Steps:**](#--ios-integration-steps---)
  - [**Step 1: Create DailymotionPlayer Folder:**](#--step-1--create-dailymotionplayer-folder---)
  - [**Step 2: Create DailymotionPlayerController.dart:**](#--step-2--create-dailymotionplayercontrollerdart---)
  - [**Step 3: Create DailymotionPlayerWidget.dart:**](#--step-3--create-dailymotionplayerwidgetdart---)
  - [**Step 4. Create Files Inside iOS Project**](#--step-4-create-files-inside-ios-project--)
  - [**Step 5: Modify AppDelegate.swift**](#--step-5--modify-appdelegateswift--)
- [**Android Integration Steps:**](#--android-integration-steps---)
  - [**Preparation**](#--preparation--)
    - [Step 1: Upgrade Kotlin Version](#step-1--upgrade-kotlin-version)
    - [Step 2: Add Maven Repository](#step-2--add-maven-repository)
    - [Step 3: Add Required Dependencies](#step-3--add-required-dependencies)
  - [**Step 1: Create DailymotionPlayer Folder:**](#--step-1--create-dailymotionplayer-folder----1)
  - [**Step 1: Modify MainActivity.kt**](#--step-1--modify-mainactivitykt--)
  - [**Step 2: Register DailymotionPlayer plugin inside MainActivity**](#--step-2--register-dailymotionplayer-plugin-inside-mainactivity--)
  - [**Step 3: Create DailymotionPlayerViewFactory**](#--step-3--create-dailymotionplayerviewfactory--)
  - [**Step 4: Create DailymotionPlayerNativeView**](#--step-4--create-dailymotionplayernativeview--)
  - [**Step 5: Create DailymotionPlayerController**](#--step-5--create-dailymotionplayercontroller--)
- [**Usage:**](#--usage---)

# **Requirements:**

- Flutter SDK is installed on your development machine.
- Xcode installed for iOS development.
- Android Studio for Android development.
- Dailymotion iOS SDK.
- Dailymotion Android SDK.
- Basic knowledge of Flutter, Android and iOS development.

# **iOS Integration Steps:**

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
    - `DailymotionPlayerPlugin.swift`
    - `DailymotionPlayerController.swift`
    - `DailymotionPlayerViewFactory.swift`

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

# **Android Integration Steps:**

## **Preparation**

This involves updating your Kotlin version, adding the necessary Maven repository, and including required dependencies in your Gradle files. Follow the steps below to prepare your project:

### Step 1: Upgrade Kotlin Version

1. Update Kotlin Plugin Version

   - Open the `settings.gradle` file at the project level (not the app level).
   - Add or update the Kotlin plugin version as follows:

   ```gradle
   id "org.jetbrains.kotlin.android" version "1.9.10" apply false\
   ```

### Step 2: Add Maven Repository

1. Include Maven Repository

   - Open the `build.gradle` file at the project level.
   - Add the Dailymotion Maven repository inside the repositories block:

   ```gradle
    allprojects {
        repositories {
            google()
            mavenCentral()
            maven {
                name = "DailymotionMavenRelease"
                url = "https://mvn.dailymotion.com/repository/releases/"
            }
        }
    }
   ```

### Step 3: Add Required Dependencies

1. Update `app/build.gradle`
   - Add the required Dailymotion SDK dependencies and other necessary libraries inside the dependencies block:
   ```gradle
   dependencies {
    implementation 'com.dailymotion.player.android:sdk:1.2.0'
    implementation 'com.dailymotion.player.android:ads:1.2.0'
    implementation 'androidx.appcompat:appcompat:1.6.1'
    implementation 'androidx.fragment:fragment-ktx:1.7.0'
   }
   ```
2. Update Minimum SDK Version

   - Ensure the minSdkVersion is set to at least 21 in the defaultConfig block:

   ```gradle
    defaultConfig {
      ...
      minSdkVersion 21

    }
   ```

With these configurations in place, your project will be ready to use the Dailymotion player SDK for Android.

## **Step 1: Create DailymotionPlayer Folder:**

Create a `DailymotionPlayer` folder inside `android/app/src/main/kotlin/com/example/flutterdailymotion`, in this folder, you need to create 3 files

1. `DailymotionPlayerViewFactory.kt`
2. `DailymotionPlayerController.kt`
3. `DailymotionPlayerNativeView.kt`

## **Step 1: Modify MainActivity.kt**

Change `FlutterActivity` to `FlutterFragmentActivity`, so it's become

```kt
class MainActivity: FlutterFragmentActivity() {
  ...
}
```

## **Step 2: Register DailymotionPlayer plugin inside MainActivity**

```kt
class MainActivity: FlutterFragmentActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        flutterEngine
                .platformViewsController
                .registry
                .registerViewFactory(
                        "dailymotion-player-view",
                        DailymotionPlayerViewFactory(
                            flutterEngine.dartExecutor.binaryMessenger,
                            supportFragmentManager
                        )
                )
    }
}
```

## **Step 3: Create DailymotionPlayerViewFactory**

after you create `android/app/src/main/kotlin/com/example/flutterdailymotion/DailymotionPlayer/DailymotionPlayerViewFactory.kt` you need to call `DailymotionPlayerNativeView` inside the `create` method:

```kt
package com.example.flutterdailymotion.DailymotionPlayer

import android.content.Context
import androidx.fragment.app.FragmentManager
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class DailymotionPlayerViewFactory(private val binaryMessenger: BinaryMessenger,private val fragmentManager: FragmentManager) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        val creationParams = args as Map<*, *>?
        return DailymotionPlayerNativeView(context, binaryMessenger, fragmentManager, viewId, creationParams)
    }
}
```

## **Step 4: Create DailymotionPlayerNativeView**

inside `android/app/src/main/kotlin/com/example/flutterdailymotion/DailymotionPlayer/DailymotionPlayerNativeView.kt` you need to call the `DailymotionPlayerController`, and you need to pass 3 parameters (`context`, `creationParams`, and `fragmentManager`), also it needs to implements the `PlatformView` and `MethodChannel.MethodCallHandler` interfaces

```kt
private val dailymotionPlayerController: DailymotionPlayerController = DailymotionPlayerController(context, creationParams, fragmentManager)
```

And inside the `getView` method, you need to return the `dailymotionPlayerController`

```kt
override fun getView(): View {
    return dailymotionPlayerController
}
```

to handling the method such as play, pause video, we need to define the method inside this file, first u need to initiate the `MethodChannel`

```kt
private val methodChannel: MethodChannel

init {
  methodChannel = MethodChannel(binaryMessenger, "dailymotion-player-channel")
  methodChannel.setMethodCallHandler(this)
}
```

override the `onMethodCall` to:

```kt
override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
  when (call.method) {
      "play" -> {
          /**
            * call play method
            */
          dailymotionPlayerController.play()
      }
      "pause" -> {
          /**
            * call pause method
            */
          dailymotionPlayerController.pause()
      }
      "load" -> {
          val videoId = call.argument<String>("videoId")
          /**
            * load video by videoId if present
            */
          if (videoId != null) {
              dailymotionPlayerController.loadVideo(videoId)
          }
      }
  }
}
```

The final file should be

```kt
package com.example.flutterdailymotion.DailymotionPlayer

import android.content.Context
import android.view.View
import androidx.fragment.app.FragmentManager
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView


class DailymotionPlayerNativeView(context: Context,  binaryMessenger: BinaryMessenger, fragmentManager: FragmentManager, id: Int, creationParams: Map<*, *>?): PlatformView, MethodChannel.MethodCallHandler {

    private val methodChannel: MethodChannel

    private val dailymotionPlayerController: DailymotionPlayerController = DailymotionPlayerController(context, creationParams, fragmentManager)

    init {
        methodChannel = MethodChannel(binaryMessenger, "dailymotion-player-channel")
        methodChannel.setMethodCallHandler(this)
    }

    override fun getView(): View {
        return dailymotionPlayerController
    }

    override fun dispose() {
        methodChannel.setMethodCallHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "play" -> {
                /**
                 * call play method
                 */
                dailymotionPlayerController.play()
            }
            "pause" -> {
                /**
                 * call pause method
                 */
                dailymotionPlayerController.pause()
            }
            "load" -> {
                val videoId = call.argument<String>("videoId")
                /**
                 * load video by videoId if present
                 */
                if (videoId != null) {
                    dailymotionPlayerController.loadVideo(videoId)
                }
            }
        }
    }
}
```

## **Step 5: Create DailymotionPlayerController**

Open `android/app/src/main/kotlin/com/example/flutterdailymotion/DailymotionPlayer/DailymotionPlayerController.kt`

1. Import Necessary Packages

```
import android.content.Context
import android.util.Log
import android.widget.FrameLayout
import androidx.fragment.app.DialogFragment
import androidx.fragment.app.FragmentManager
import com.dailymotion.android.player.sdk.PlayerError
import com.dailymotion.android.player.sdk.PlayerListener
import com.dailymotion.android.player.sdk.PlayerView
import com.dailymotion.android.player.sdk.Dailymotion

```

2. Declare the class
   - Declare the `DailymotionPlayerController` class inheriting from `FrameLayout`.
   - Define the class constructor with parameters: `context`, `creationParams`, and `fragmentManager`.

```kt
class DailymotionPlayerController(
    context: Context,
    creationParams: Map<*, *>?,
    fragmentManager: FragmentManager
) : FrameLayout(context)

```

3. Define Properties

Declare properties for `playerView`, `videoId`, `playerId`, and logTag.

```kt
    private lateinit var playerView: PlayerView
    private var videoId: String = ""
    private var playerId: String = ""

    val logTag = "Dailymotion-Flutter-${Dailymotion.version()}"


```

4. Initialize the Class

```kt
init {
  // Safely cast and extract parameters
  videoId = creationParams?.get("videoId") as? String ?: ""
  playerId = creationParams?.get("playerId") as? String ?: ""
}
```

5. Create Dailymotion Player at initialization step

```kt
init{
  ...
  Dailymotion.createPlayer(
            context = context,
            playerId = playerId,
            videoId = videoId,
            playerSetupListener = object : Dailymotion.PlayerSetupListener {
                override fun onPlayerSetupSuccess(player: PlayerView) {
                    playerView = player

                    Log.d(logTag, "Successfully created dailymotion player")

                    // Make sure the layout size follows the parent size
                    val lp = LayoutParams(
                        LayoutParams.MATCH_PARENT,
                        LayoutParams.MATCH_PARENT
                    )

                    // Add Dailymotion player to view
                    this@DailymotionPlayerController.addView(player, lp)
                    Log.d(logTag, "Added dailymotion player to view hierarchy")
                }

                override fun onPlayerSetupFailed(error: PlayerError) {
                    Log.e(logTag, "Error while creating dailymotion player: ${error.message}")
                }
            },
            playerListener = object : PlayerListener {
                override fun onFullscreenRequested(playerDialogFragment: DialogFragment) {
                    super.onFullscreenRequested(playerDialogFragment)
                    playerDialogFragment.show(fragmentManager, "dmPlayerFullscreenFragment")
                }
            }
        )
}
```

6. Add `play`, `pause`, and `loadVideo` method into the class

```kt
  fun pause (){
        Log.d(logTag, "Pause")
        playerView.pause()
    }


    fun play (){

        Log.d(logTag, "Play")
        playerView.play()
    }

    fun loadVideo(videoId: String){
        Log.d(logTag, "Load video $videoId")
        playerView.loadContent(videoId)
    }
```

Full code

```kt
package com.example.flutterdailymotion.DailymotionPlayer

import android.content.Context
import android.util.Log
import android.widget.FrameLayout
import androidx.fragment.app.DialogFragment
import androidx.fragment.app.FragmentManager
import com.dailymotion.player.android.sdk.Dailymotion
import com.dailymotion.player.android.sdk.PlayerView
import com.dailymotion.player.android.sdk.listeners.PlayerListener
import com.dailymotion.player.android.sdk.webview.error.PlayerError


class DailymotionPlayerController(context: Context, creationParams: Map<*, *>?, fragmentManager: FragmentManager): FrameLayout(context) {
    private lateinit var playerView: PlayerView
    private var videoId: String = ""
    private var playerId: String = ""

    /**
     * define log name
     */
    val logTag = "Dailymotion-Flutter-${Dailymotion.version()}"

    init {
        // Safely cast and extract parameters
        videoId = creationParams?.get("videoId") as? String ?: ""
        playerId = creationParams?.get("playerId") as? String ?: ""

        Dailymotion.createPlayer(
            context= context,
            playerId = playerId,
            videoId = videoId,
            playerSetupListener = object : Dailymotion.PlayerSetupListener {
                override fun onPlayerSetupSuccess(player: PlayerView) {
                    playerView = player

                    Log.d(logTag, "Successfully created dailymotion player")

                    /**
                     * make sure the layout size are following the parent size
                     */
                    val lp = LayoutParams(
                            LayoutParams.MATCH_PARENT,
                            LayoutParams.MATCH_PARENT
                    )

                    /**
                     * add dailymotion player to view
                     */
                    this@DailymotionPlayerController.addView(player, lp)
                    Log.d(logTag, "Added dailymotion player to view hierarchy")
                }

                override fun onPlayerSetupFailed(error: PlayerError) {
                    Log.e(logTag, "Error while creating dailymotion player: ${error.message}")
                }
            },
            playerListener = object : PlayerListener {
                override fun onFullscreenRequested(playerDialogFragment: DialogFragment) {
                    super.onFullscreenRequested(playerDialogFragment)
                    playerDialogFragment.show(fragmentManager, "dmPlayerFullscreenFragment")
                }
            }

        )
    }

    fun pause (){
        Log.d(logTag, "Pause")
        playerView.pause()
    }


    fun play (){

        Log.d(logTag, "Play")
        playerView.play()
    }

    fun loadVideo(videoId: String){
        Log.d(logTag, "Load video $videoId")
        playerView.loadContent(videoId)
    }
}
```

# **Usage:**

To use the `DailymotionPlayerWidget` in your Flutter app, simply instantiate a `DailymotionPlayerController` with the required parameters (videoId and playerId) and pass it to the `DailymotionPlayerWidget` , example:

```dart
import 'package:flutter/material.dart';
import 'package:flutterdailymotion/DailymotionPlayer/DailymotionPlayerController.dart';
import 'package:flutterdailymotion/DailymotionPlayer/DailymotionPlayerWidget.dart';

class _MyHomePageState extends State<MyHomePage> {
  /**
   * Initiate DailymotionController
   */
  late DailymotionPlayerController dmController;

  @override
  void initState() {
    super.initState();

    /**
     * Pass videoId and playerId to DailymotionPlayerController
     */
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
        /**
        * pass controller to DailymotionPlayerWidget
        */
        DailymotionPlayerWidget(controller: dmController),
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
