import Flutter
import UIKit

class DailymotionPlayerPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let factory = DailymotionPlayerViewFactory(messenger: registrar.messenger())
        registrar.register(factory, withId: "dailymotion-player-view")
    }
}
