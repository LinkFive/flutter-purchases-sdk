package io.linkfive.linkfive_purchases

import android.util.Log
import io.flutter.plugin.common.EventChannel
import io.linkfive.purchases.LinkFivePurchases
import io.linkfive.purchases.util.Logger
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.Job
import kotlinx.coroutines.flow.collect
import kotlinx.coroutines.launch

class LinkFiveObserver {

    private var globalScopeResponseFlowJob: Job? = null
    private var globalScopeSubFlowJob: Job? = null
    private var globalScopeActiveFlowJob: Job? = null

    var eventChannelResponse: EventChannel.EventSink? = null
    var eventChannelSubscription: EventChannel.EventSink? = null

    init {
        initGlobalScope()
    }

    fun initGlobalScope(){
        onDestroy()
        Log.d("LinkFive", "create global scopes")
        globalScopeResponseFlowJob = GlobalScope.launch(Dispatchers.Main) {
            LinkFivePurchases.linkFiveSubscriptionResponseFlow().collect { data ->
                Logger.d("FLOW: got data Response: $data")

                if (data != null) {
                    val parsedData = mapOf(
                        "platform" to data.platform,
                        "subscriptionList" to data.subscriptionList.map { responseData ->
                            mapOf("sku" to responseData.sku)
                        }.toList()
                    )
                    eventChannelResponse?.success(parsedData)
                }
            }
        }
        globalScopeSubFlowJob = GlobalScope.launch(Dispatchers.Main) {
            LinkFivePurchases.linkFiveSubscriptionFlow().collect { data ->
                Logger.d("FLOW: got data Subscription: $data")

                if (data != null) {
                    val parsedData = mapOf(
                        "linkFiveSkuData" to data.linkFiveSkuData?.map {
                            mapOf(
                                "skuDetails" to it.skuDetails.let { skuDetails ->
                                    mapOf(
                                        "sku" to skuDetails.sku,
                                        "subscriptionPeriod" to skuDetails.subscriptionPeriod,
                                        "price" to skuDetails.price,
                                        "introductoryPrice" to skuDetails.introductoryPrice,
                                        "introductoryPricePeriod" to skuDetails.introductoryPricePeriod,
                                        "title" to skuDetails.title,
                                        "description" to skuDetails.description,
                                        "freeTrialPeriod" to skuDetails.freeTrialPeriod,
                                        "type" to skuDetails.type,
                                    )
                                }
                            )
                        }
                    )
                    /**
                     * {linkFiveSkuData=[[{skuDetails={sku=3monateblasubscri, subscriptionPeriod=P3M, price=0,99 €, introductoryPrice=, introductoryPricePeriod=, title=super awesome subscription (com.tnx.keller_app (unreviewed)), description=This is the description, freeTrialPeriod=P1W, type=subs}}, {skuDetails={sku=testsubscription2022, subscriptionPeriod=P6M, price=1,49 €, introductoryPrice=, introductoryPricePeriod=, title=test subscription 2022 (com.tnx.keller_app (unreviewed)), description=test, freeTrialPeriod=P1W, type=subs}}]]}
                     */

                    Logger.d(parsedData)
                    eventChannelSubscription?.success(parsedData)
                }
            }
        }
        globalScopeActiveFlowJob = GlobalScope.launch(Dispatchers.Main) {
            LinkFivePurchases.linkFiveActivePurchasesFlow().collect { data ->
                Logger.d("FLOW: got data Active: $data")

                if (data != null) {
                    data.linkFiveSkuData?.map {

                    }
                    val skuDetails = mapOf(
                        "sku" to "qwe",
                        "subscriptionPeriod" to "P3M",
                        "price" to "1,99 €",
                        "introductoryPrice" to null,
                        "introductoryPricePeriod" to null,
                        "title" to "Title",
                        "description" to "description",
                        "freeTrialPeriod" to "P7D",
                        "type" to "SUB",
                    )
                    val linkFiveSkuData = mapOf(
                        "skuDetails" to skuDetails
                    )

                    val linkFiveSubscriptionData = mapOf(
                        "linkFiveSkuData" to listOf(linkFiveSkuData)
                    )
                }


            }
        }
    }

    fun onDestroy() {
        Log.d("LinkFive", "destroy global scopes")
        globalScopeResponseFlowJob?.cancel()
        globalScopeSubFlowJob?.cancel()
        globalScopeActiveFlowJob?.cancel()
    }
}
/*

                val skuDetails = mapOf(
                    "sku" to "qwe",
                    "subscriptionPeriod" to "P3M",
                    "price" to "1,99 €",
                    "introductoryPrice" to null,
                    "introductoryPricePeriod" to null,
                    "title" to "Title",
                    "description" to "description",
                    "freeTrialPeriod" to "P7D",
                    "type" to "SUB",
                )
                val linkFiveSkuData = mapOf(
                    "skuDetails" to skuDetails
                )

                val linkFiveSubscriptionData = mapOf(
                    "linkFiveSkuData" to listOf(linkFiveSkuData)
                )
 */