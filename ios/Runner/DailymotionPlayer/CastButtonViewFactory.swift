//
//  CastButtonViewFactory.swift
//  Runner
//
//  Created by Arryangga Aliev Pratamaputra on 04/10/24.
//

import GoogleCast

class CastButtonViewFactory: NSObject, FlutterPlatformViewFactory {
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
        return CastButtonNativeView(frame: frame)
    }
    
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
}


class CastButtonNativeView: NSObject, FlutterPlatformView {
    private var _view: UIView
    
    init(frame: CGRect) {
        _view = GCKUICastButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        _view.isUserInteractionEnabled = true
        super.init()
    }
    
    func view() -> UIView {
        return _view
    }
}
