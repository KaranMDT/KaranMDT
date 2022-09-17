import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/Provider/orders.dart';

class OrderItems extends StatefulWidget {
  final orderItem orders;
  const OrderItems({Key? key, required this.orders}) : super(key: key);

  @override
  State<OrderItems> createState() => _OrderItemsState();
}

class _OrderItemsState extends State<OrderItems> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _expanded
          ? min(
              widget.orders.products.length * 20 + 110,
              200,
            )
          : 95,
      child: Card(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: Text(
                "\$" + widget.orders.amount.toStringAsFixed(2),
                style: const TextStyle(fontSize: 18),
              ),
              subtitle: Text(
                DateFormat("dd/MM/yyyy   hh:mm").format(widget.orders.date),
                style: const TextStyle(fontSize: 16),
              ),
              trailing: IconButton(
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: _expanded
                  ? min(widget.orders.products.length * 20 + 10, 100)
                  : 0,
              child: ListView(
                padding: const EdgeInsets.all(10),
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                children: [
                  ...widget.orders.products
                      .map(
                        (e) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              e.title,
                              style: const TextStyle(fontSize: 18),
                            ),
                            Text(
                              e.quantity.toString() +
                                  "x" +
                                  "\$" +
                                  e.price.toString(),
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
