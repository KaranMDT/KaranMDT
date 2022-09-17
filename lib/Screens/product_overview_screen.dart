import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Provider/products.dart';
import 'package:shop_app/Screens/cart_screen.dart';
import 'package:shop_app/widgets/badge.dart';
import 'package:shop_app/widgets/drawer.dart';
import '../Provider/cart.dart';
import '../widgets/products_grid.dart';

enum favouritefilter { favourite, all }

class ProductOverviewScreen extends StatefulWidget {
  const ProductOverviewScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool _showonlyfavourite = false;
  var _isinit = true;
  var isload = true;

  @override
  void didChangeDependencies() {
    if (_isinit) {
      setState(() {
        isload = true;
      });
      Provider.of<Products>(context).fatchdata(true).then(
        (value) {
          setState(() {
            isload = false;
          });
        },
      );
    }
    _isinit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("My Shop App"),
        actions: [
          Consumer<Cart>(
            builder: ((context, value, ch) => Badge(
                child: ch!,
                value: value.itemcount.toString(),
                color: Theme.of(context).primaryColor)),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: ((context) => const CartScreen()),
                  ),
                );
              },
            ),
          ),
          PopupMenuButton(
            onSelected: (favouritefilter selectvalue) {
              setState(() {
                if (selectvalue == favouritefilter.favourite) {
                  _showonlyfavourite = true;
                } else {
                  _showonlyfavourite = false;
                }
              });
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                child: Text("Show Favourite"),
                value: favouritefilter.favourite,
              ),
              PopupMenuItem(
                child: Text("Show All"),
                value: favouritefilter.all,
              )
            ],
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: isload
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ProductGrid(showfav: _showonlyfavourite),
    );
  }
}
