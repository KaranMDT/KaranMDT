import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Provider/cart.dart';

class CartItemwidget extends StatelessWidget {
  final String id;
  final String title;
  final double price;
  final int quantity;
  final String productid;
  const CartItemwidget({
    Key? key,
    required this.id,
    required this.title,
    required this.price,
    required this.quantity,
    required this.productid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).primaryColor,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productid);
      },
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Are You Sure?"),
                content: const Text("Do You Want to Remove Item In Cart?"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: const Text("No"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: const Text("Yes"),
                  ),
                ],
              );
            });
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
                backgroundColor: Theme.of(context).primaryColorLight,
                radius: 30,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FittedBox(
                      child: Text(
                    "\$" + price.toString(),
                    style: const TextStyle(color: Colors.black),
                  )),
                )),
            title: Text(title),
            subtitle: Text("Total:\$${price * quantity}"),
            trailing: Text(quantity.toString() + "x"),
          ),
        ),
      ),
    );
  }
}
