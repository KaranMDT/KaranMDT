import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_app/model/meal.dart';
import 'package:food_app/Screens/mealdetail_screen.dart';

import 'catagorylist.dart';

class Mealitem extends StatefulWidget {
  final String id;
  final String title;
  final String imageurl;
  final String duration;
  final Affordability affordablity;
  final Complexity complexity;

  const Mealitem(
      {Key? key,
      required this.id,
      required this.affordablity,
      required this.duration,
      required this.imageurl,
      required this.title,
      required this.complexity})
      : super(key: key);

  @override
  State<Mealitem> createState() => _MealitemState();
}

class _MealitemState extends State<Mealitem> {
  String? get complexitymeal {
    switch (widget.complexity) {
      case Complexity.Simple:
        return "Simple";
        break;
      case Complexity.Challenging:
        return "Challenging";
        break;
      case Complexity.Hard:
        return "Hard";
        break;
      default:
        "Unknown";
    }
  }

  String? get affordablitymeal {
    switch (widget.affordablity) {
      case Affordability.Affordable:
        return "Affordable";
        break;
      case Affordability.Luxurious:
        return "Luxurious";
        break;
      case Affordability.Pricey:
        return "Spicey";
        break;

      default:
        return "Unknown";
    }
  }

  void togglefavourite(String mealId) {
    final existingid =
        favouritemeal.indexWhere((element) => element.id == mealId);
    if (existingid >= 0) {
      setState(() {
        favouritemeal.removeAt(existingid);
      });
    } else {
      setState(() {
        favouritemeal.add(
          DUMMY_MEALS.firstWhere((element) => element.id == mealId),
        );
      });
    }
  }

  bool ismealfavourite(String id) {
    return favouritemeal.any((element) => element.id == id);
  }

  void selectmeal(BuildContext context) {
    Navigator.of(context).push(
      CupertinoPageRoute(builder: (context) {
        return MealDetail(
          istogglefavourite: ismealfavourite,
          togglefavouriteofmeal: togglefavourite,
          mealid: widget.id,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        selectmeal(context);
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 25),
        borderOnForeground: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 6,
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  child: Image.network(
                    widget.imageurl,
                    height: MediaQuery.of(context).size.height / 4,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 10,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    width: MediaQuery.of(context).size.width / 2,
                    color: Colors.black54,
                    child: Text(
                      widget.title,
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                      softWrap: true,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.schedule),
                      const SizedBox(
                        width: 6,
                      ),
                      Text(widget.duration + 'min'),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.work),
                      const SizedBox(
                        width: 6,
                      ),
                      Text(complexitymeal.toString()),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.attach_money),
                      const SizedBox(
                        width: 6,
                      ),
                      Text(affordablitymeal.toString())
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
