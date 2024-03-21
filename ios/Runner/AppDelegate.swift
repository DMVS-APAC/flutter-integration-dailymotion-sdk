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
