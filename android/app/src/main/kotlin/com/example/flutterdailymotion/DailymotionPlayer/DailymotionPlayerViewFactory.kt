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

