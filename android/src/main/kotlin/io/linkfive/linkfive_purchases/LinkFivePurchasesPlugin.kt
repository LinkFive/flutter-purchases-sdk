package io.linkfive.linkfive_purchases

import android.app.Activity
import android.content.Context
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.linkfive.purchases.LinkFivePurchases
import io.linkfive.purchases.util.Logger

class LinkFivePurchasesPlugin : FlutterPlugin, MethodCallHandler, ActivityAware,
    EventChannel.StreamHandler {

    private lateinit var channelMethods: MethodChannel
    private lateinit var channelEvent: EventChannel
    private lateinit var activity: Activity
    private lateinit var context: Context

    private val androidObserver = LinkFiveObserver()


    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "linkfive_init" -> {
                val apiKey = call.argument<String>("apiKey")
                val acknowledgeLocally = call.argument<Boolean>("acknowledgeLocally") ?: false
                if (apiKey.isNullOrBlank()) {
                    result.error(
                        "-1",
                        "LinkFive Api Key is null",
                        "Please provide an api key"
                    )
                    return
                }
                onInit(apiKey, acknowledgeLocally)
                result.success("ok")
            }
            "linkfive_fetch" -> onFetchSubscriptions(result)
            else -> result.notImplemented()
        }
    }

    private fun onInit(apiKey: String, acknowledgeLocally: Boolean = false) {
        LinkFivePurchases.init(
            apiKey = apiKey,
            context = context,
            acknowledgeLocally = acknowledgeLocally
        )

        // LinkFivePurchases.linkFiveSubscriptionLiveData().observe(activity, subscriptionDataObserver)
    }

    private fun onFetchSubscriptions(result: Result) {
        LinkFivePurchases.fetch(context)
        result.success("ok")
    }

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channelMethods = MethodChannel(flutterPluginBinding.binaryMessenger, "linkfive_methods")
        channelMethods.setMethodCallHandler(this)
        channelEvent = EventChannel(flutterPluginBinding.binaryMessenger, "linkfive_events")
        channelEvent.setStreamHandler(this)
        context = flutterPluginBinding.applicationContext
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channelMethods.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity;
    }

    override fun onDetachedFromActivityForConfigChanges() {
        // TODO("Not yet implemented")
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        // TODO("Not yet implemented")
    }

    override fun onDetachedFromActivity() {
        // TODO("Not yet implemented")
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        Logger.d("LISTEN")
        androidObserver.responseEventChannel = events
    }

    override fun onCancel(arguments: Any?) {
        Logger.d("CANCEL")
        // androidObserver.responseEventChannel = null
    }
}
