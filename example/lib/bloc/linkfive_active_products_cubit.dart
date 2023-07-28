import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkfive_purchases/linkfive_purchases.dart';
import 'package:linkfive_purchases_example/bloc/linkfive_active_products_state.dart';

class LinkFiveActiveProductsCubit extends Cubit<LinkFiveActiveProductsState> {
  /// LinkFive client
  final LinkFivePurchasesImpl linkFivePurchases = LinkFivePurchasesImpl();

  /// Stream that will be cleaned on close
  StreamSubscription? _stream;

  LinkFiveActiveProductsCubit() : super(LinkFiveActiveProductsInitState()) {
    _stream =
        linkFivePurchases.activeProducts.listen(_activeSubscriptionDataUpdate);
  }

  /// Saves active Subscriptions and notifies all listeners
  void _activeSubscriptionDataUpdate(LinkFiveActiveProducts data) {
    emit(LinkFiveActiveProductsLoadedState(data));
  }

  @override
  Future<void> close() {
    _stream?.cancel();
    return super.close();
  }
}
