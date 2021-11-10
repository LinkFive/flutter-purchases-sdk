import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkfive_purchases_example/bloc/linkfive_active_products_cubit.dart';
import 'package:linkfive_purchases_example/bloc/linkfive_products_cubit.dart';
import 'package:linkfive_purchases_example/main.dart';
import 'package:linkfive_purchases_example/page/bloc/bloc_paywall.dart';
import 'package:linkfive_purchases_provider/linkfive_purchases_provider.dart';

class BlocPaywallPage extends Page {
  BlocPaywallPage() : super(key: ValueKey("BlocPaywallPage")) {
    LinkFivePurchases.init(MyApp.linkFiveApiKey,
        env: LinkFiveEnvironment.STAGING);
  }

  @override
  Route createRoute(BuildContext context) => MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) {
        return MultiBlocProvider(providers: [
          BlocProvider<LinkFiveProductsCubit>(create: (context) => LinkFiveProductsCubit()),
          BlocProvider<LinkFiveActiveProductsCubit>(create: (context) => LinkFiveActiveProductsCubit())
        ], child: BlocPaywall());
      });
}
