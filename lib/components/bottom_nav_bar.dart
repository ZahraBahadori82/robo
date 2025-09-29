import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MyBottomNavBar extends StatefulWidget {
 void Function(int)? onTabChange;
 MyBottomNavBar({super.key, required this.onTabChange});

  @override
  State<MyBottomNavBar> createState() => _MyBottomNavBarState();
}

class _MyBottomNavBarState extends State<MyBottomNavBar> {
 @override
  Widget build(BuildContext context) {
   return Container(
    margin:const EdgeInsets.all(25),

   child: GNav(
    onTabChange: (value) => widget.onTabChange!(value) ,
    color: Colors.grey[400],
       mainAxisAlignment: MainAxisAlignment.center,
       activeColor: Colors.grey[700],
       tabBackgroundColor: Colors.grey.shade100,
       tabBorderRadius: 24,
       tabActiveBorder: Border.all(color: Colors.white),


       tabs:[
    GButton(icon: Icons.home, text: 'Shop',),

    GButton(icon: Icons.shopping_bag_outlined, text:'Cart',)
   ])
  );
  }
}