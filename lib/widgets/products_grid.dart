import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop_app/widgets/product_item.dart';

import '../Provider/products.dart';

class ProductGrid extends StatelessWidget {
  final bool showfav;
  ProductGrid({required this.showfav});
  @override
  Widget build(BuildContext context) {
    final productsdata = Provider.of<Products>(context);
    final products = showfav ? productsdata.favouriteitem : productsdata.items;

    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return ChangeNotifierProvider.value(
          value: products[index],
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 5,
            child: const ProductItem(),
          ),
        );
      },
    );
  }
}
