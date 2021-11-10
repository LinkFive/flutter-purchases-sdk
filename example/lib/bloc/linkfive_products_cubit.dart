import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkfive_purchases/linkfive_purchases.dart';
import 'package:linkfive_purchases_example/bloc/linkfive_products_state.dart';

class LinkFiveProductsCubit extends Cubit<LinkFiveProductsState>{

  /// LinkFive client
  final LinkFivePurchasesMain linkFivePurchases = LinkFivePurchasesMain();

  /// Stream that will be cleaned on close
  StreamSubscription? _stream;

  LinkFiveProductsCubit() : super(LinkFiveProductsInitState()){
    _stream = LinkFivePurchases
        .listenOnSubscriptionData()
        .listen(_subscriptionDataUpdate);
  }

  /// Saves available Subscriptions and notifies all listeners
  void _subscriptionDataUpdate(LinkFiveSubscriptionData? data) async {
    if(data != null) {
      emit(LinkFiveProductsLoadedState(data));
    }
  }

  @override
  Future<void> close() {
    _stream?.cancel();
    return super.close();
  }
}