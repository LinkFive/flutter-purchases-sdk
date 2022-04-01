import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkfive_purchases_example/bloc/linkfive_active_products_cubit.dart';
import 'package:linkfive_purchases_example/bloc/linkfive_products_cubit.dart';
import 'package:linkfive_purchases_example/page/bloc/bloc_paywall.dart';
import 'package:linkfive_purchases_example/page/bloc/bloc_raw.dart';

class BlocPaywallPage extends Page {

  // 1 == raw
  // 2 == paywall
  final int page;

  BlocPaywallPage(this.page) : super(key: ValueKey("BlocPaywallPage")) {
  }

  @override
  Route createRoute(BuildContext context) => MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) {
        return MultiBlocProvider(providers: [
          BlocProvider<LinkFiveProductsCubit>(
              create: (context) => LinkFiveProductsCubit()),
          BlocProvider<LinkFiveActiveProductsCubit>(
              create: (context) => LinkFiveActiveProductsCubit())
        ], child: page == 1 ? BlocRaw() : BlocPaywall());
      });
}
