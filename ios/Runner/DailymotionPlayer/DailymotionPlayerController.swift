//
//  DailymotionPlayerController.swift
//  Runner
//
//  Created by Arryangga Putra on 15-03-2024.
//

import Foundation
import UIKit
import DailymotionPlayerSDK
import SwiftUI

class DailymotionPlayerController: UIViewController, ObservableObject, DMVideoDelegate{
    
    var playerId: String?
    var videoId: String = ""
    var playerView: DMPlayerView?
    var parameters: DMPlayerParameters?
    var frame: CGRect
    
    // Initialize the class with playerId and videoId
    init(frame: CGRect, playerId: String?, videoId: String, parameters: DMPlayerParameters? = nil) {
        self.playerId = playerId
        self.videoId = videoId
        self.parameters = parameters ?? DMPlayerParameters(mute: false, defaultFullscreenOrientation: .portrait)
        self.frame = frame
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
            await initPlayer()
        }
    }
    
    
    func initPlayer(with parameters: DMPlayerParameters? = nil) async {
        do {
            let playerView = try await Dailymotion.createPlayer(playerId: playerId ?? "xix5x", videoId: videoId, playerParameters: (parameters ?? self.parameters)!, playerDelegate: self, videoDelegate: self, logLevels: [.all])
            addPlayerView(playerView: playerView)
        } catch {
            handlePlayerError(error: error)
        }
    }
    
    
    private func addPlayerView(playerView: DMPlayerView) {
        self.playerView = playerView
        self.view.addSubview(playerView)
        
        playerView.frame = CGRect(origin: CGPoint.zero, size: self.view.bounds.size)
        playerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            playerView.topAnchor.constraint(equalTo: view.topAnchor),
            playerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            playerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            playerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        print("Player view added", self.playerView!)
        
        
    }
    
    func play() {
        self.playerView?.play()
    }
    
    func pause() {
        self.playerView?.pause()
    }
    
    func load(videoId: String) {
        self.playerView?.loadContent(videoId: videoId)
    }
    
    
    func handlePlayerError(error: Error) {
        switch(error) {
        case PlayerError.advertisingModuleMissing :
            break;
        case PlayerError.stateNotAvailable :
            break;
        case PlayerError.underlyingRemoteError(error: let error):
            let error = error as NSError
            if let errDescription = error.userInfo[NSLocalizedDescriptionKey],
               let errCode = error.userInfo[NSLocalizedFailureReasonErrorKey],
               let recovery = error.userInfo[NSLocalizedRecoverySuggestionErrorKey] {
                print("Player Error : Description: \(errDescription), Code: \(errCode), Recovery : \(recovery) ")
                
            } else {
                print("Player Error : \(error)")
            }
            break
        case PlayerError.requestTimedOut:
            print(error.localizedDescription)
            break
        case PlayerError.unexpected:
            print(error.localizedDescription)
            break
        case PlayerError.internetNotConnected:
            print(error.localizedDescription)
            break
        case PlayerError.playerIdNotFound:
            print(error.localizedDescription)
            break
        case PlayerError.otherPlayerRequestError:
            print(error.localizedDescription)
            break
        default:
            print(error.localizedDescription)
            break
        }
    }
}


extension DailymotionPlayerController: DMPlayerDelegate {
    func playerWillPresentFullscreenViewController(_ player: DMPlayerView) -> UIViewController? {
        return self
    }
    
    func playerWillPresentAdInParentViewController(_ player: DMPlayerView) -> UIViewController {
        return self
    }

    func player(_ player: DMPlayerView, openUrl url: URL) {
        
    }
}
