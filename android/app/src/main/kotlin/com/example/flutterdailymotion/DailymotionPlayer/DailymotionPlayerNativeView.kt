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