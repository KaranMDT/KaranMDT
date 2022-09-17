import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/orders.dart';
import 'package:shop_app/widgets/drawer.dart';
import 'package:shop_app/widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  Future<void> _fatchdata(BuildContext context) async {
    await Provider.of<Order>(context, listen: false).fatchorders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Orders"),
        elevation: 0,
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _fatchdata(context),
        child: FutureBuilder(
          future: _fatchdata(context),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.error != null) {
              return const Center(
                child: Text("you have not ordered!"),
              );
            }
            return Consumer<Order>(
              builder: ((context, value, child) => ListView.builder(
                    itemCount: value.orders.length,
                    itemBuilder: (BuildContext context, int index) {
                      return OrderItems(
                        orders: value.orders[index],
                      );
                    },
                  )),
            );
          },
        ),
      ),
    );
  }
}
