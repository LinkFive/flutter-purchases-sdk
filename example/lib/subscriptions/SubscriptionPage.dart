import 'package:flutter/material.dart';
import 'package:linkfive_purchases/linkfive_purchases.dart';
import 'package:linkfive_purchases_example/subscriptions/subscription_active.dart';
import 'package:linkfive_purchases_example/subscriptions/subscription_offering.dart';
import 'package:linkfive_purchases_example/subscriptions/subscription_response.dart';

class SubscriptionPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(8),
        child: StreamBuilder<bool>(
          stream: LinkFivePurchases.listenOnShouldShowPendingUI(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              bool shouldShowPendingUI = snapshot.data ?? false;

              if (shouldShowPendingUI) {
                return Center(child: CircularProgressIndicator());
              } else {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      SubscriptionResponse(),
                      SubscriptionOffering(),
                      SubscriptionActive(),
                      ElevatedButton(
                          onPressed: () async {
                            await LinkFivePurchases.restore();
                          },
                          child: const Text('restore'))
                    ],
                  ),
                );
              }
            }
            return Center(child: Text('Loading...'));
          },
        ));
  }
}
