import 'package:flutter/material.dart';
import 'package:food_app/Screens/filter_screen.dart';
import 'package:food_app/main.dart';
import '../catagorylist.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  Widget buildtile(String title, IconData icon, Function taphandler) {
    return ListTile(
      leading: Icon(
        icon,
        size: 20,
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      onTap: () {
        taphandler();
      },
    );
  }

  void setfilters(Map<String, bool> filterdata) {
    setState(() {
      filters = filterdata;
      availablemeals = DUMMY_MEALS.where(
        (element) {
          if (filters['gluteen'] == true && !element.isGlutenFree) {
            return false;
          }
          if (filters['lectose'] == true && !element.isLactoseFree) {
            return false;
          }
          if (filters['vegan'] == true && !element.isVegan) {
            return false;
          }
          if (filters['vegetarian'] == true && !element.isVegetarian) {
            return false;
          }
          return true;
        },
      ).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 10,
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 5,
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            alignment: Alignment.center,
            color: Colors.yellow,
            child: const Text(
              "Cooking up",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 24,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          buildtile("Meals", Icons.restaurant, () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return const MyApp();
                },
              ),
            );
          }),
          buildtile("Filters", Icons.settings, () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return FilterScreen(
                    savemeal: setfilters,
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
