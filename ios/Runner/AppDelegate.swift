import UIKit
import Flutter
import FirebaseCore
import FirebaseAnalytics

@main
@objc class AppDelegate: FlutterAppDelegate {
    private let channelName = "com.pokedex"

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        GeneratedPluginRegistrant.register(with: self)

        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }

        let controller = window?.rootViewController as! FlutterViewController
        let analyticsChannel = FlutterMethodChannel(
            name: channelName,
            binaryMessenger: controller.binaryMessenger
        )

        analyticsChannel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
            switch call.method {
            case "logEvent":
                if let args = call.arguments as? [String: Any],
                   let name = args["name"] as? String {
                    let params = args["params"] as? [String: Any] ?? [:]
                    Analytics.logEvent(name, parameters: params)
                }
                result(nil)

            default:
                result(FlutterMethodNotImplemented)
            }
        }

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}