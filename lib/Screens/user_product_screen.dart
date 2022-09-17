import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Screens/edit_product_screen.dart';

import '../Provider/products.dart';
import '../widgets/drawer.dart';
import '../widgets/user_product_item.dart';

class UserProductScreen extends StatelessWidget {
  const UserProductScreen({
    Key? key,
  }) : super(key: key);

  Future<void> _refresh(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fatchdata(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Your Products"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: ((context) {
                    return const EditProductscreen();
                  }),
                ),
              );
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: _refresh(context),
        builder: (context, snapdata) =>
            snapdata.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refresh(context),
                    child: Consumer<Products>(
                      builder: (context, value, child) => Padding(
                          padding: const EdgeInsets.all(10),
                          child: ListView.builder(
                            itemCount: value.items.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                children: [
                                  UserProductItem(
                                    id: value.items[index].id,
                                    title: value.items[index].title,
                                    imageurl: value.items[index].imageUrl,
                                  ),
                                  const Divider()
                                ],
                              );
                            },
                          )),
                    ),
                  ),
      ),
    );
  }
}
