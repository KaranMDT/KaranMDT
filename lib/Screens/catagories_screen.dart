import 'package:flutter/material.dart';
import 'package:food_app/catagory_item.dart';

import 'package:food_app/catagorylist.dart';
import 'package:food_app/widgets/drawer.dart';

class CatagoriesScreen extends StatefulWidget {
  const CatagoriesScreen({Key? key}) : super(key: key);

  @override
  State<CatagoriesScreen> createState() => _CatagoriesScreenState();
}

class _CatagoriesScreenState extends State<CatagoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MainDrawer(),
      appBar: AppBar(
        title: const Text("Catagories"),
      ),
      body: GridView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(25),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 1,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20),
        children: dummycatagory.map((data) {
          return CatagoryItem(
            title: data.title,
            color: data.color,
            id: data.id,
          );
        }).toList(),
      ),
    );
  }
}
