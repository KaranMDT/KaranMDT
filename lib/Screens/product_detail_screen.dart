import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/products.dart';

class ProductDetailScreen extends StatelessWidget {
  final String productid;
  const ProductDetailScreen({Key? key, required this.productid})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loadedproduct =
        Provider.of<Products>(context, listen: false).findbyid(productid);

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(loadedproduct.title),
      // ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                loadedproduct.title,
              ),
              background: Hero(
                tag: loadedproduct.id,
                child: Image.network(
                  loadedproduct.imageUrl,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "\$" + loadedproduct.price.toString(),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  loadedproduct.description,
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
                const SizedBox(
                  height: 800,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
