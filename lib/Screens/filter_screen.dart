import 'package:flutter/material.dart';
import 'package:food_app/widgets/drawer.dart';

import '../catagorylist.dart';

class FilterScreen extends StatefulWidget {
  final Function savemeal;

  const FilterScreen({
    Key? key,
    required this.savemeal,
  }) : super(key: key);

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  bool _isglutinfree = false;
  bool _isvegetarian = false;
  bool _isvegan = false;
  bool _islactosefree = false;

  @override
  void initState() {
    _isglutinfree = filters['gluteen'] ?? false;
    _islactosefree = filters['lectose'] ?? false;
    _isvegan = filters['vegan'] ?? false;
    _isvegetarian = filters['vegetarian'] ?? false;

    super.initState();
  }

  @override
  Widget buildswitchtile(
    String title,
    String descreption,
    bool currentvalue,
    Function(bool) taphandler,
  ) {
    return SwitchListTile(
        title: Text(title),
        subtitle: Text(descreption),
        value: currentvalue,
        onChanged: taphandler);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MainDrawer(),
      appBar: AppBar(
        title: const Text("Settings"),
        actions: [
          IconButton(
            onPressed: () {
              filters = {
                'gluteen': _isglutinfree,
                'lectose': _islactosefree,
                'vegan': _isvegan,
                'vegetarian': _isvegetarian,
              };
              widget.savemeal(filters);
            },
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            child: const Text("Adjust Your meal Selection"),
            padding: const EdgeInsets.all(8),
          ),
          Expanded(
            child: ListView(
              children: [
                buildswitchtile(
                  "Gluteen Free",
                  "Only include Gluteen Free Meal",
                  _isglutinfree,
                  (newvalue) {
                    setState(() {
                      _isglutinfree = newvalue;
                    });
                  },
                ),
                buildswitchtile(
                  "Lactose Free",
                  "Only include Lactose Free Meal",
                  _islactosefree,
                  (newvalue) {
                    setState(() {
                      _islactosefree = newvalue;
                    });
                  },
                ),
                buildswitchtile(
                  "Vagetarian",
                  "Only include Vegetarian Meal",
                  _isvegetarian,
                  (newvalue) {
                    setState(() {
                      _isvegetarian = newvalue;
                    });
                  },
                ),
                buildswitchtile(
                  "Vegan",
                  "Only include Vegan Meal",
                  _isvegan,
                  (newvalue) {
                    setState(() {
                      _isvegan = newvalue;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
