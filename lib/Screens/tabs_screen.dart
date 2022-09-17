import 'package:flutter/material.dart';
import 'package:food_app/Screens/catagories_screen.dart';
import 'package:food_app/Screens/favourite_screen.dart';
import 'package:food_app/model/meal.dart';

class Tabbarscreen extends StatefulWidget {
  final List<Meal> favouritedlist;
  const Tabbarscreen({Key? key, required this.favouritedlist})
      : super(key: key);

  @override
  State<Tabbarscreen> createState() => _TabbarscreenState();
}

class _TabbarscreenState extends State<Tabbarscreen> {
  List<Widget>? pages;
  int selectepageindex = 0;

  @override
  void initState() {
    pages = [
      const CatagoriesScreen(),
      FavouriteScreen(
        favouritescreenmeal: widget.favouritedlist,
      ),
    ];
    super.initState();
  }

  void selectpage(int index) {
    setState(() {
      selectepageindex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.yellow,
        selectedFontSize: 15,
        unselectedFontSize: 15,
        elevation: 5,
        iconSize: 25,
        landscapeLayout: BottomNavigationBarLandscapeLayout.spread,
        backgroundColor: Theme.of(context).primaryColor,
        currentIndex: selectepageindex,
        onTap: selectpage,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: "Catagory",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: "favourite",
          ),
        ],
      ),
      body: pages![selectepageindex],
    );
  }
}
