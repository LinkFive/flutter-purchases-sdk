
import 'package:equatable/equatable.dart';
import 'package:linkfive_purchases/linkfive_purchases.dart';

abstract class LinkFiveProductsState extends Equatable{

  @override
  List<Object> get props => [];
}

class LinkFiveProductsInitState extends LinkFiveProductsState {
}

class LinkFiveProductsLoadedState extends LinkFiveProductsState {

  final LinkFiveProducts products;

  LinkFiveProductsLoadedState(this.products);

  @override
  List<Object> get props => products.productDetailList;
}
