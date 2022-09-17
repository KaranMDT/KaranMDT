import 'package:flutter/material.dart';
import 'package:food_app/model/meal.dart';
import 'package:food_app/widgets/drawer.dart';

import '../mealitem.dart';

class FavouriteScreen extends StatelessWidget {
  final List<Meal> favouritescreenmeal;
  const FavouriteScreen({Key? key, required this.favouritescreenmeal})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      drawer: const MainDrawer(),
      appBar: AppBar(
        title: const Text("Favourite Item"),
      ),
      body: favouritescreenmeal.isNotEmpty
          ? ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              itemCount: favouritescreenmeal.length,
              itemBuilder: (BuildContext context, int index) {
                return Mealitem(
                  id: favouritescreenmeal[index].id,
                  affordablity: favouritescreenmeal[index].affordability,
                  duration: favouritescreenmeal[index].duration.toString(),
                  imageurl: favouritescreenmeal[index].imageUrl,
                  title: favouritescreenmeal[index].title,
                  complexity: favouritescreenmeal[index].complexity,
                );
              },
            )
          : const Center(
              child: Text("You Have Not Added Favourite ItemYet!"),
            ),
    );
  }
}
