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

class LinkFivePurchasesPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {

    private lateinit var channelMethods: MethodChannel
    private lateinit var channelEventResponse: EventChannel
    private lateinit var channelEventSubscriptions: EventChannel
    private lateinit var activity: Activity
    private lateinit var context: Context

    private lateinit var linkFiveObserver: LinkFiveObserver

    /**
     * Initial Flutter call to attach the channels
     */
    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext
        linkFiveObserver = LinkFiveObserver()
        Logger.d("ATTACHED")
        Logger.d("ATTACHED2")
        Logger.d("ATTACHED3")
        Logger.d("ATTACHED4")

        channelMethods = MethodChannel(flutterPluginBinding.binaryMessenger, "linkfive_methods")
        channelMethods.setMethodCallHandler(this)

        LinkFiveEventChannel.initChannel(flutterPluginBinding, linkFiveObserver)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "linkfive_init" -> {
                linkFiveObserver.initGlobalScope()
                Logger.d("qwerty")
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
    }

    private fun onFetchSubscriptions(result: Result) {
        LinkFivePurchases.fetch(context)
        result.success("ok")
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
}
