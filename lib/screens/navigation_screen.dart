import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:food_order_app/screens/cart_screen.dart';
import 'package:food_order_app/screens/category_screen.dart';
import 'package:food_order_app/screens/home_screen.dart';
import 'package:food_order_app/screens/orders_screen.dart';
import 'package:food_order_app/utils/constants.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});
  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int selectedIndex = 0;
  var screens = [
    const HomeScreen(),
    const CategoryScreen(),
    const Cartscreen(),
    const OrdersScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        color: primaryColor, // Color of the navigation bar
        buttonBackgroundColor: secondaryColor, // Active button color
        backgroundColor: Colors.transparent,

        height: 60,
        animationDuration: const Duration(milliseconds: 300),
        items: [
          Icon(
            Icons.home,
            size: 30,
            color: selectedIndex == 0 ? Colors.white : Colors.white,
          ),
          Icon(
            Icons.category,
            size: 30,
            color: selectedIndex == 1 ? Colors.white : Colors.white,
          ),
          Icon(
            Icons.shopping_cart,
            size: 30,
            color: selectedIndex == 2 ? Colors.white : Colors.white,
          ),
          Icon(
            Icons.receipt,
            size: 30,
            color: selectedIndex == 3 ? Colors.white : Colors.white,
          ),
        ],
        onTap: (index) {
          setState(() {
            selectedIndex = index; // Change selected page
          });
        },
      ),
    );
  }
}
