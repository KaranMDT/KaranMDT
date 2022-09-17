import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop_app/Screens/product_detail_screen.dart';

import '../Provider/Product.dart';
import '../Provider/auth.dart';
import '../Provider/cart.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Product>(
      context,
    );
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(10),
        topLeft: Radius.circular(10),
        bottomLeft: Radius.circular(10),
        bottomRight: Radius.circular(10),
      ),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return ProductDetailScreen(productid: productData.id);
                },
              ),
            );
          },
          child: Hero(
            tag: productData.id,
            child: FadeInImage(
              placeholder: const AssetImage("images/placeholder.png"),
              image: NetworkImage(productData.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        footer: GridTileBar(
          backgroundColor: const Color.fromRGBO(0, 0, 0, 0.541),
          leading: Consumer<Product>(
            builder: (context, value, child) => IconButton(
              onPressed: () {
                value.toggleFavouriteStatus(
                  authData.token.toString(),
                  authData.userid,
                );
              },
              icon: Icon(
                value.isfavourite ? Icons.favorite : Icons.favorite_border,
                color: Colors.deepOrange,
              ),
            ),
          ),
          title: Text(
            productData.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            onPressed: () {
              cart.addItem(
                  productData.id, productData.title, productData.price);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text("Your item is added in cart"),
                  duration: const Duration(seconds: 2),
                  action: SnackBarAction(
                      label: "UNDO",
                      onPressed: () {
                        cart.removeSingleItem(productData.id);
                      }),
                ),
              );
            },
            icon: const Icon(Icons.shopping_cart, color: Colors.deepOrange),
          ),
        ),
      ),
    );
  }
}
