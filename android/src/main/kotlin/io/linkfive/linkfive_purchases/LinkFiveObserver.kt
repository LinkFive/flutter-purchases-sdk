package io.linkfive.linkfive_purchases

import androidx.lifecycle.Observer
import io.flutter.plugin.common.EventChannel
import io.linkfive.purchases.LinkFivePurchases
import io.linkfive.purchases.models.LinkFiveActiveSubscriptionData
import io.linkfive.purchases.models.LinkFiveSubscriptionData
import io.linkfive.purchases.util.Logger
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.Job
import kotlinx.coroutines.flow.collect
import kotlinx.coroutines.launch

class LinkFiveObserver {

    private val globalScopeResponseFlowJob: Job
    private val globalScopeSubFlowJob: Job
    private val globalScopeActiveFlowJob: Job

    var responseEventChannel: EventChannel.EventSink? = null

    init {
        globalScopeResponseFlowJob = GlobalScope.launch(Dispatchers.Main) {
            LinkFivePurchases.linkFiveSubscriptionResponseFlow().collect { data ->
                Logger.d("FLOW: got data Response: $data")

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

                responseEventChannel?.success(linkFiveSubscriptionData)
            }
        }
        globalScopeSubFlowJob = GlobalScope.launch {
            LinkFivePurchases.linkFiveSubscriptionFlow().collect {
                Logger.d("FLOW: got data Subscription: $it")
            }
        }
        globalScopeActiveFlowJob = GlobalScope.launch {
            LinkFivePurchases.linkFiveActivePurchasesFlow().collect {
                Logger.d("FLOW: got data Active: $it")
            }
        }
    }

    fun onDestroy(){
        globalScopeActiveFlowJob.cancel()
        globalScopeSubFlowJob.cancel()
        globalScopeActiveFlowJob.cancel()
    }
}