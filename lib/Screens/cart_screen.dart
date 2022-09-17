import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Provider/orders.dart';
import 'package:shop_app/widgets/cart_item.dart';

import '../Provider/cart.dart';
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Your Cart"),
      ),
      body: Column(
        children: [
          Card(
            elevation: 5,
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total",
                    style: TextStyle(fontSize: 18),
                  ),
                  const Spacer(),
                  Chip(
                      label: Text("\$${cart.totalAmount.toStringAsFixed(2)}"),
                      backgroundColor: Theme.of(context).primaryColorLight),
                  Expanded(
                      child: OrderButton(
                    cartdata: cart,
                  )),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: cart.items.length,
              itemBuilder: (BuildContext context, int index) {
                return CartItemwidget(
                  id: cart.items.values.toList()[index].id,
                  title: cart.items.values.toList()[index].title,
                  quantity: cart.items.values.toList()[index].quantity,
                  price: cart.items.values.toList()[index].price,
                  productid: cart.items.keys.toList()[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  final Cart cartdata;

  const OrderButton({Key? key, required this.cartdata}) : super(key: key);

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isloading = false;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: widget.cartdata.totalAmount != 0
          ? () async {
              setState(() {
                _isloading = true;
              });
              await Provider.of<Order>(context, listen: false).addOrders(
                  widget.cartdata.items.values.toList(),
                  widget.cartdata.totalAmount);
              setState(() {
                _isloading = false;
              });

              widget.cartdata.clear();
            }
          : null,
      child: _isloading
          ? const CircularProgressIndicator()
          : const Text("ORDER NOW"),
    );
  }
}
