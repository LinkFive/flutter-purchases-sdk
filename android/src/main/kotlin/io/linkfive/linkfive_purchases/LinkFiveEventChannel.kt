package io.linkfive.linkfive_purchases

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.linkfive.purchases.util.Logger

object LinkFiveEventChannel {

    private val channelEventResponseName = "linkfive_events_response"
    private lateinit var channelEventResponse: EventChannel
    private val channelEventSubscriptionsName = "linkfive_events_subscription"
    private lateinit var channelEventSubscriptions: EventChannel
    private val channelEventActiveSubscriptionsName = "linkfive_events_active_subscription"
    private lateinit var channelEventActiveSubscriptions: EventChannel

    fun initChannel(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding, androidObserver: LinkFiveObserver) {
        initResponseChannel(flutterPluginBinding, androidObserver)
        initSubscriptionChannel(flutterPluginBinding, androidObserver)
        initActiveSubscriptionChannel(flutterPluginBinding, androidObserver)
    }

    private fun initResponseChannel(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding, androidObserver: LinkFiveObserver) {
        channelEventResponse = EventChannel(flutterPluginBinding.binaryMessenger, channelEventResponseName)
        channelEventResponse.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                Logger.d("Response Channel Listen")
                androidObserver.eventChannelResponse = events
            }

            override fun onCancel(arguments: Any?) {
                Logger.d("Response Channel Cancel")
            }

        })
    }

    private fun initSubscriptionChannel(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding, androidObserver: LinkFiveObserver) {
        channelEventSubscriptions = EventChannel(flutterPluginBinding.binaryMessenger, channelEventSubscriptionsName)
        channelEventSubscriptions.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                Logger.d("Subscription Channel Listen")
                androidObserver.eventChannelSubscription = events
            }

            override fun onCancel(arguments: Any?) {
                Logger.d("Subscription Channel Cancel")
            }

        })
    }

    private fun initActiveSubscriptionChannel(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding, androidObserver: LinkFiveObserver) {
        channelEventActiveSubscriptions = EventChannel(flutterPluginBinding.binaryMessenger, channelEventActiveSubscriptionsName)
        channelEventActiveSubscriptions.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                Logger.d("Subscription Channel Listen")
                androidObserver.eventChannelActiveSubscription = events
            }

            override fun onCancel(arguments: Any?) {
                Logger.d("Subscription Channel Cancel")
            }

        })
    }
}