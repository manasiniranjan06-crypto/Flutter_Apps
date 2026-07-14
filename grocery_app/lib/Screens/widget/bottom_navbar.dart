import 'package:flutter/material.dart';
import 'package:grocery_app/Screens/view/ExploreProduct.dart';
import 'package:grocery_app/Screens/view/cart_page.dart';
import 'package:grocery_app/Screens/view/favScreen.dart';
import 'package:grocery_app/Screens/view/homeScreen.dart';

class BottomNavbar extends StatefulWidget {
  final int initialIndex;
  const BottomNavbar({super.key, this.initialIndex = 0});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: pages(currentIndex),

      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        elevation: 8,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: SizedBox(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [

              // ---------- SHOP ----------
              _navItem(
                index: 0,
                icon: "assets/productpge/store1.png",
                label: "Shop",
              ),

              // ---------- EXPLORE ----------
              _navItem(
                index: 1,
                icon: "assets/productpge/store2.png",
                label: "Explore",
              ),

              // ---------- CART ----------
              _navItem(
                index: 2,
                icon: "assets/productpge/store3.png",
                label: "Cart",
              ),

              // ---------- FAVOURITE ----------
              _navItem(
                index: 3,
                icon: "assets/productpge/store4.png",
                label: "Favourite",
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------- NAV ITEM WIDGET ----------
  Widget _navItem({
    required int index,
    required String icon,
    required String label,
  }) {
    final isActive = currentIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () => setState(() => currentIndex = index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImageIcon(
              AssetImage(icon),
              size: 30,
              color: isActive ? Colors.green : Colors.black,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: isActive ? Colors.green : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- PAGES ----------
  Widget pages(int index) {
    switch (index) {
      case 0:
        return  Homescreen();
      case 1:
        return  ExploreProduct();
      case 2:
        return  CartPage(); // cart page later
      case 3:
        return  Favscreen(); // favourite page later
      default:
        return  Homescreen();
    }
  }
}
