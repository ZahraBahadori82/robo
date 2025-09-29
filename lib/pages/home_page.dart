import 'package:flutter/material.dart';
import 'package:robo/components/bottom_nav_bar.dart';
import 'package:robo/const.dart';
import 'package:robo/main.dart';
import 'package:path/path.dart';

import 'package:robo/pages/shop_page.dart';

import 'package:drift/drift.dart' as drift;
import 'cart_page.dart';

class HomePage extends StatefulWidget {
  final String? tableId;
  final String? restaurantId;

  const HomePage({
    super.key,
    this.tableId,
    this.restaurantId,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _isDrawerOpen = false;

  String? username = 'Guest';

  late AnimationController _drawerAnimationController;
  late Animation<Offset> _slideAnimation;
  String? userEmail = 'guest@example.com'; // We'll override this from database later

  @override
  void initState() {
    super.initState();

    _drawerAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _drawerAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  void navigateBottomBar(int index) {
    setState(() => _selectedIndex = index);
  }

  void toggleDrawer() {
    setState(() {
      _isDrawerOpen = !_isDrawerOpen;
      _isDrawerOpen
          ? _drawerAnimationController.forward()
          : _drawerAnimationController.reverse();
    });
  }

  // Updated to pass table info to CartPage
  List<Widget> get _pages => [
    ShopPage(),
    CartPage(
      tableId: widget.tableId,
      restaurantId: widget.restaurantId,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      bottomNavigationBar: MyBottomNavBar(
        onTabChange: (index) => navigateBottomBar(index),
      ),
      body: Stack(
        children: [
          // Main content
          SafeArea(
            child: Column(
              children: [
                // App bar with profile icon
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Welcome Back", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      GestureDetector(
                        onTap: toggleDrawer,
                        child: const CircleAvatar(
                          backgroundColor: Colors.white60,
                          backgroundImage: AssetImage('lib/image/profile.png'),
                        ),
                      ),
                    ],
                  ),
                ),

                // NEW: Show table info if coming from QR code
                if (widget.tableId != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.brown.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.brown.shade200),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.table_restaurant, color: Colors.brown.shade600),
                            const SizedBox(width: 8),
                            Text(
                              'Table ${widget.tableId}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.brown.shade800,
                              ),
                            ),
                          ],
                        ),
                        if (widget.restaurantId != null)
                          Text(
                            'Restaurant: ${widget.restaurantId}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.brown.shade600,
                            ),
                          ),
                      ],
                    ),
                  ),

                Expanded(child: _pages[_selectedIndex]),
              ],
            ),
          ),

          // Your existing drawer code (unchanged)
          SlideTransition(
            position: _slideAnimation,
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: 250,
                height: MediaQuery.of(context).size.height,
                color: Colors.brown,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: toggleDrawer,
                      ),
                    ),
                    const CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white60,
                      backgroundImage: AssetImage('lib/image/profile.png'),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      username ?? 'Guest',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(userEmail ?? 'guest@example.com',
                        style: const TextStyle(color: Colors.white70)),

                    const SizedBox(height: 30),
                    drawerItem(Icons.receipt_long, 'My Orders'),
                    drawerItem(Icons.person, 'My Profile'),
                    drawerItem(Icons.location_on, 'Delivery Address'),
                    drawerItem(Icons.credit_card, 'Payment Methods'),
                    drawerItem(Icons.contact_support, 'Contact Us'),
                    drawerItem(Icons.settings, 'Settings'),
                    drawerItem(Icons.help_outline, 'Help & FAQs'),
                    const Spacer(),
                    ElevatedButton.icon(
                      onPressed: () async {
                        toggleDrawer();
                        setState(() {
                          userEmail = 'guest@example.com';
                          username = 'Guest';
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Logged out')),
                        );
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text("Log Out"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.brown,
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget drawerItem(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 10),
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 16)),
        ],
      ),
    );
  }
}