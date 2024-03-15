import Flutter
import UIKit
import DailymotionPlayerSDK
import SwiftUI



class FLNativeViewFactory: NSObject, FlutterPlatformViewFactory {
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
        return FLNativeView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            binaryMessenger: messenger)
    }
    
    /// Implementing this method is only necessary when the `arguments` in `createWithFrame` is not `nil`.
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
}

class FLNativeView: NSObject, FlutterPlatformView {
    private var _view: UIView
    
    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger?
    ) {
        _view = UIView()
        super.init()
        
        // iOS views can be created here
        createNativeView(view: _view)
    }
    
    func view() -> UIView {
        return _view
    }
    
    func createNativeView(view _view: UIView){
        
        // default parameter of dailymotion player
        let defaultParameters = DMPlayerParameters(mute: true, defaultFullscreenOrientation: .landscapeLeft)
        
        
        // Create an instance of DailymotionPlayerController
        let dailymotionPlayerController = DailymotionPlayerController(playerId: "xqzrc", videoId: "x8q4e1z",parameters: defaultParameters)
        
        // Add the Dailymotion player's view as a subview to the provided _view
        if let playerView = dailymotionPlayerController.view {
            
            playerView.frame = _view.bounds
            playerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            _view.addSubview(playerView)
           
        } else {
            print("Error: Dailymotion player's view is nil")
        }
        
    }
}
