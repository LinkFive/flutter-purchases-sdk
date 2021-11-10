
import 'package:equatable/equatable.dart';
import 'package:linkfive_purchases/linkfive_purchases.dart';

abstract class LinkFiveActiveProductsState extends Equatable{

  @override
  List<Object> get props => [];
}

class LinkFiveActiveProductsInitState extends LinkFiveActiveProductsState {
}

class LinkFiveActiveProductsLoadedState extends LinkFiveActiveProductsState {

  final LinkFiveActiveSubscriptionData activeProducts;

  LinkFiveActiveProductsLoadedState(this.activeProducts);

  @override
  List<Object> get props => activeProducts.subscriptionList;
}
