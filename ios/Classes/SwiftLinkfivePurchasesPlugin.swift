import Flutter
import UIKit

public class SwiftLinkfivePurchasesPlugin: NSObject, FlutterPlugin {

    private struct Methods {
        static let launch = "linkfive_init"
        static let fetchSubscriptions = "linkfive_fetch"
        static let purchase = "linkfive_purchase"
        static let restore = "restore"
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "linkfive_methods", binaryMessenger: registrar.messenger())
        let instance = SwiftLinkfivePurchasesPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let arguments = call.arguments as? [String: Any] else {
            result(FlutterError.init(code: "BAD_ARGS",
                                         message: "args missing)" ,
                                         details: nil))
                return
        }

        let method = call.method
        
        switch method {
        case Methods.launch:
            guard let apiKey = arguments["apiKey"] as? String else {
                result(FlutterError.init(code: "BAD_ARGS",
                                         message: "apiKey missing)" ,
                                         details: nil))
                return
            }

            let acknowledgeLocally = arguments["acknowledgeLocally"] as? Bool ?? false
            launch(key: apiKey, acknowledgeLocally: acknowledgeLocally)
            result("ok")
        case Methods.fetchSubscriptions:
            guard let apiKey = arguments["apiKey"] as? String else {
                result(FlutterError.init(code: "BAD_ARGS",
                                         message: "apiKey missing)" ,
                                         details: nil))
                return
            }

            let acknowledgeLocally = arguments["acknowledgeLocally"] as? Bool ?? false
            fetch(key: apiKey, acknowledgeLocally: acknowledgeLocally)
            result("ok")
        case Methods.purchase:
            guard let sku = arguments["sku"] as? String, let type = arguments["type"] as? String else {
                result(FlutterError.init(code: "BAD_ARGS",
                                         message: "sku / type missing)" ,
                                         details: nil))
                return
            }

            purchase(sku: sku, type: type)
        case Methods.restore:
            break
        default:
            print("Unknown method!")
            break
        }
    }
    
    private func launch(key: String, acknowledgeLocally: Bool) {
        
    }

    private func fetch(key: String, acknowledgeLocally: Bool) {
        
    }

    private func purchase(sku: String, type: String) {

    }
}
