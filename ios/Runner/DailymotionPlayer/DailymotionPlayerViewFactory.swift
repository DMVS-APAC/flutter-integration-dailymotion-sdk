import Flutter
import UIKit
import DailymotionPlayerSDK
import SwiftUI



class DailymotionPlayerViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger
    
    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }
    
    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        let nativeView = DailymotionPlayerNativeView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            binaryMessenger: messenger)
        // Register method channel
        let channel = FlutterMethodChannel(name: "dailymotion-player-channel", binaryMessenger: messenger)
        channel.setMethodCallHandler { [weak nativeView] (call, result) in
            if call.method == "play" {
                nativeView?.play()
                result(nil)
            } else if call.method == "pause" {
                nativeView?.pause()
                result(nil)
            } else if call.method == "load", let args = call.arguments as? [String: Any], let videoId = args["videoId"] as? String {
                nativeView?.load(videoId: videoId)
                result(nil)
            } else {
                result(FlutterMethodNotImplemented)
            }
        }
        
        
        return nativeView
    }
    
    /// Implementing this method is only necessary when the `arguments` in `createWithFrame` is not `nil`.
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
}

class DailymotionPlayerNativeView: NSObject, FlutterPlatformView{
    private var _view: UIView
    var _videoId: String
    var _playerId: String
    let dailymotionPlayerController: DailymotionPlayerController
    
    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger?
    ) {
        _view = UIView()
        // Check if args is a dictionary and cast it to [String: Any]
        if let argsDict = args as? [String: Any] {
            // Retrieve videoId and playerId from argsDict
            _videoId = argsDict["videoId"] as? String ?? ""
            _playerId = argsDict["playerId"] as? String ?? ""
        } else {
            // Set default values if args is nil or not a dictionary
            _videoId = ""
            _playerId = ""
        }
        
        
        let defaultParameters = DMPlayerParameters(mute: true, defaultFullscreenOrientation: .landscapeRight)
        
        
        // Create an instance of DailymotionPlayerController
        self.dailymotionPlayerController = DailymotionPlayerController(parent: _view, playerId: _playerId, videoId: _videoId, parameters: defaultParameters)
        
        
        super.init()
        
        
        //
        //
        //        // iOS views can be created here
        //        createNativeView(view: _view)
    }
    
    func view() -> UIView {
        //         Add the Dailymotion player's view as a subview to the provided _view
        if let playerView = dailymotionPlayerController.view {
            playerView.frame = _view.bounds
            playerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            _view.addSubview(playerView)
            return _view
            
        } else {
            print("Error: Dailymotion player's view is nil")
        }
        return _view
    }
    
    func play() {
        dailymotionPlayerController.play()
    }
    
    func pause() {
        dailymotionPlayerController.pause()
    }
    
    func load(videoId:String) {
        dailymotionPlayerController.load(videoId: videoId)
    }
}
