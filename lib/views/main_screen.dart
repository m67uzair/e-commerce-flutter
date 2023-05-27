import 'package:flutter/material.dart';

import 'favorites_screen.dart';
import 'home_screen.dart';
import 'my_cart_screen.dart';
import 'profile_screen.dart';
import 'shop_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static List<Widget> navigationWidgets = [
    const HomeScreen(),
    ShopScreen(),
    const MyCartScreen(),
    const FavoritesScreen(),
    const ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        unselectedItemColor: const Color(0xFF9B9B9B),
        selectedItemColor: Colors.red,
        onTap: onItemTapped,
        currentIndex: _selectedIndex,
        elevation: 2,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.house_outlined,
                color: Color(0xFF9B9B9B),
              ),
              activeIcon: Icon(Icons.home, color: Colors.red),
              label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.storefront_outlined,
              ),
              activeIcon: Icon(Icons.storefront_rounded, color: Colors.red),
              label: "Shop"),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined, color: Color(0xFF9B9B9B)),
              activeIcon: Icon(Icons.shopping_cart, color: Colors.red),
              label: "My Cart"),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border, color: Color(0xFF9B9B9B)),
            activeIcon: Icon(Icons.favorite, color: Colors.red),
            label: "Favorites",
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person_2_outlined,
                color: Color(0xFF9B9B9B),
              ),
              activeIcon: Icon(Icons.person_2_rounded, color: Colors.red),
              label: "Profile"),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
          children: navigationWidgets
      ),
    );
  }
}
