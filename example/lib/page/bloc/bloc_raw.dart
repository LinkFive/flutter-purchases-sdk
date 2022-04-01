import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkfive_purchases_example/bloc/linkfive_active_products_cubit.dart';
import 'package:linkfive_purchases_example/bloc/linkfive_active_products_state.dart';
import 'package:linkfive_purchases_example/bloc/linkfive_products_cubit.dart';
import 'package:linkfive_purchases_example/bloc/linkfive_products_state.dart';
import 'package:linkfive_purchases_provider/linkfive_purchases_provider.dart';

class BlocRaw extends StatelessWidget {
  BlocRaw() {
    // when using the Raw methods, we have to fetch the subscriptions manually
    LinkFivePurchases.fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Bloc Raw"),
        ),
        body: Column(
          children: [
            BlocBuilder<LinkFiveProductsCubit, LinkFiveProductsState>(
                builder: (context, state) {
              if (state is LinkFiveProductsLoadedState) {
                if (state.products.productDetailList.length > 0) {
                  return Container(
                    margin: EdgeInsets.all(16),
                    child: Column(
                        children: state.products.productDetailList
                            .map((e) => ElevatedButton(
                                onPressed: () => LinkFivePurchases.purchase(
                                    e.productDetails),
                                child: Text(e.productDetails.title)))
                            .toList()),
                  );
                }
              }
              return Text("No products");
            }),
            BlocBuilder<LinkFiveActiveProductsCubit,
                LinkFiveActiveProductsState>(builder: (context, state) {
              if (state is LinkFiveActiveProductsLoadedState) {
                if (state.activeProducts.planList.length > 0) {
                  return Container(
                      margin: EdgeInsets.all(16),
                      child: Text(
                          "${state.activeProducts.planList.map((e) => e.planId)}"));
                }
              }
              return Text("Nothing purchased yet");
            })
          ],
        ));
  }
}
