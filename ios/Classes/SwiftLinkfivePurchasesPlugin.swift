import Flutter
import UIKit
import LinkFivePurchases

public class SwiftLinkfivePurchasesPlugin: NSObject, FlutterPlugin {

    private struct Methods {
        static let launch = "linkfive_init"
        static let fetchSubscriptions = "linkfive_fetch"
        static let purchase = "linkfive_purchase"
        static let restore = "restore"
    }

    private struct Channels {
        static let methods = "linkfive_methods"
        static let eventsResponse = "linkfive_events_response"
        static let eventsSubscription = "linkfive_events_subscription"
        static let eventsActiveSubscription = "linkfive_events_active_subscription"
    }

    enum FlutterErrorCode: String {
        case fetchingFailed
    }

    private let eventsResponseStreamHandler = SwiftStreamHandler()
    private let eventsSubscriptionStreamHandler = SwiftStreamHandler()
    private let eventsActiveSubscriptionStreamHandler = SwiftStreamHandler()
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        // Method channel
        let channel = FlutterMethodChannel(name: "linkfive_methods", binaryMessenger: registrar.messenger())
        let instance = SwiftLinkfivePurchasesPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)

        // Event channels
        let eventsResponseChannel = FlutterEventChannel(name: Channels.eventsResponse, binaryMessenger: registrar.messenger())
        eventsResponseChannel.setStreamHandler(StreamHandlers.shared.eventsResponseStreamHandler)
        let eventsSubscriptionChannel = FlutterEventChannel(name: Channels.eventsSubscription, binaryMessenger: registrar.messenger())
        eventsSubscriptionChannel.setStreamHandler(StreamHandlers.shared.eventsSubscriptionStreamHandler)
        let eventsActiveSubscriptionChannel = FlutterEventChannel(name: Channels.eventsActiveSubscription, binaryMessenger: registrar.messenger())
        eventsActiveSubscriptionChannel.setStreamHandler(StreamHandlers.shared.eventsActiveSubscriptionStreamHandler)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let arguments = call.arguments as? [String: Any] else {
            result(FlutterError.init(code: "BAD_ARGS",
                                         message: "args missing)" ,
                                         details: nil))
                return
        }
        
        switch call.method {
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
            let acknowledgeLocally = arguments["acknowledgeLocally"] as? Bool ?? false
            fetch()
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
        LinkFivePurchases.shared.launch(with: key)
    }

    private func fetch() {
        LinkFivePurchases.shared.fetchSubscriptions { result in
            switch result {
            case .success(let subscriptions):
                let subscriptionList = subscriptions.compactMap({ ["sku": $0] })
                let response = ["platform": "IOS",
                                "subscriptionList": subscriptionList]
                StreamHandlers.shared.eventsResponseStreamHandler.eventSink?(response)
            case .failure(let error):
                let flutterError = FlutterError(code: FlutterErrorCode.fetchingFailed.rawValue,
                                                message: error.localizedDescription,
                                                details: nil)
                // TODO: What to do with errors?
                // StreamHandlers.shared.eventsResponseStreamHandler.eventSink?(flutterError)
            }
        }
    }

    private func purchase(sku: String, type: String) {

    }
}

struct StreamHandlers {
    public static let shared = StreamHandlers()

    let eventsResponseStreamHandler = SwiftStreamHandler()
    let eventsSubscriptionStreamHandler = SwiftStreamHandler()
    let eventsActiveSubscriptionStreamHandler = SwiftStreamHandler()
}

final class SwiftStreamHandler: NSObject, FlutterStreamHandler {             
    public var eventSink: FlutterEventSink?

    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {       
        self.eventSink = events
        return nil                                                                                                                                                                           
    }                                                                                                                                                                                        

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {               
        self.eventSink = nil                                                                                                    
        return nil                                                                                                                                                                           
    }                                                                                                                                                                                        
}

