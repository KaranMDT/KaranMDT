import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Screens/catagory_meal_screen.dart';

class CatagoryItem extends StatefulWidget {
//  final List<Meal> availablemeals;
  final String id;
  final String title;
  final Color color;
 const CatagoryItem(
      {Key? key,

      // required this.availablemeals,
      required this.title,
      required this.color,
      required this.id})
      : super(key: key);

  @override
  State<CatagoryItem> createState() => _CatagoryItemState();
}

class _CatagoryItemState extends State<CatagoryItem> {
  void selectcatagory(BuildContext context) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) {
          return CatagoryMealScreen(
            catagorytitle: widget.title,
            catagoryid: widget.id,
            catagorycolor: widget.color,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        selectcatagory(context);
      },
      child: Container(
        child: Text(
          widget.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [widget.color.withOpacity(0.65), widget.color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
