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