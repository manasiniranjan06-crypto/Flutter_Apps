import 'package:firebaseauth/customerside/screens/category_screen.dart';
import 'package:firebaseauth/customerside/screens/favorites_screen.dart';
import 'package:firebaseauth/customerside/screens/home_screen.dart';
import 'package:firebaseauth/customerside/screens/order_screen.dart';
import 'package:firebaseauth/customerside/screens/profile_screen.dart';
import 'package:flutter/material.dart';


class CustomBottomBar extends StatefulWidget {
  const CustomBottomBar({super.key});

  @override
  State<CustomBottomBar> createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
  int currentIndex = 0;

  List<Widget> pageList = [
    const CustomerHomeScreen(),
    const CategoryPage(),
    const OrdersPage(),
    const FavoritesPage(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pageList.elementAt(currentIndex),
      bottomNavigationBar: _buildFloatingNavBar(context),
    );
  }

  Widget _buildFloatingNavBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        height: 65,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 25,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildCustomNavItem(Icons.home_rounded, 0, 'Home'),
            _buildCustomNavItem(Icons.category_rounded, 1, 'Categories'),
            _buildCustomNavItem(Icons.shopping_bag_rounded, 2, 'Orders'),
            _buildCustomNavItem(Icons.favorite_rounded, 3, 'Favorites'),
            _buildCustomNavItem(Icons.person_rounded, 4, 'Profile'),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomNavItem(IconData icon, int index, String label) {
    bool isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          currentIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 20 : 12,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF8075FF).withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFF8075FF) : Colors.grey[600],
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isSelected ? const Color(0xFF8075FF) : Colors.grey[600],
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}