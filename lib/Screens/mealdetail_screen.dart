import 'package:flutter/material.dart';
import 'package:food_app/catagorylist.dart';

class MealDetail extends StatefulWidget {
  final String mealid;
  Function togglefavouriteofmeal;
  Function istogglefavourite;
  MealDetail({
    Key? key,
    required this.mealid,
    required this.togglefavouriteofmeal,
    required this.istogglefavourite,
  }) : super(key: key);

  @override
  State<MealDetail> createState() => _MealDetailState();
}

class _MealDetailState extends State<MealDetail> {
  @override
  Widget buildcontainer(Widget child) {
    return Container(
      width: 300,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10)),
      child: child,
    );
  }

  Widget buildSelectiontile(BuildContext context, String text) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Text(
        text,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  bool isfav = true;

  @override
  Widget build(BuildContext context) {
    final selectmeal = DUMMY_MEALS.firstWhere((dummymeal) {
      return dummymeal.id == widget.mealid;
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(selectmeal.title),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          widget.istogglefavourite(widget.mealid)
              ? (Icons.star)
              : (Icons.star_border),
        ),
        onPressed: () {
          setState(() {
            isfav = !isfav;
            widget.togglefavouriteofmeal(widget.mealid);
          });
        },
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 3,
            width: double.infinity,
            child: Image.network(
              selectmeal.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          buildSelectiontile(context, "Ingrediant"),
          buildcontainer(
            ListView.builder(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: selectmeal.ingredients.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.amberAccent,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    child: Text(selectmeal.ingredients[index]),
                  ),
                );
              },
            ),
          ),
          buildSelectiontile(context, "Steps"),
          buildcontainer(
            ListView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemCount: selectmeal.steps.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        child: Text("#${index + 1}"),
                      ),
                      title: Text(selectmeal.steps[index]),
                    ),
                    const Divider(),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
