import 'package:flutter/material.dart';
import 'package:food_app/catagorylist.dart';
import 'package:food_app/mealitem.dart';

class CatagoryMealScreen extends StatelessWidget {
  
  final String catagoryid;
  final String catagorytitle;
  final Color catagorycolor;
  const CatagoryMealScreen(
      {Key? key,
      
      required this.catagorytitle,
      required this.catagoryid,
      required this.catagorycolor})
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    final catagrymeal = availablemeals.where((meal) {
      return meal.categories.contains(catagoryid);
    }).toList();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(catagorytitle),
      ),
      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        itemCount: catagrymeal.length,
        itemBuilder: (BuildContext context, int index) {
          return Mealitem(
            id: catagrymeal[index].id,
            affordablity: catagrymeal[index].affordability,
            duration: catagrymeal[index].duration.toString(),
            imageurl: catagrymeal[index].imageUrl,
            title: catagrymeal[index].title,
            complexity: catagrymeal[index].complexity,
          );
        },
      ),
    );
  }
}
