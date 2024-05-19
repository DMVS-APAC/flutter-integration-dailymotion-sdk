package com.example.flutterdailymotion

import com.example.flutterdailymotion.DailymotionPlayer.DailymotionPlayerViewFactory
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine

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
