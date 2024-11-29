
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:milkminder/calender.dart';
import 'package:milkminder/homepage.dart';
import 'package:milkminder/profile.dart';
import 'package:milkminder/receipt_page.dart';
import 'package:milkminder/rewards_Page.dart';


class HomeScreen extends StatefulWidget {
  final String userEmail;

  const HomeScreen({super.key, required this.userEmail});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          const HomePage(),
          ReceiptPage(email: widget.userEmail),
          RewardsPage(email: widget.userEmail), // New RewardsPage widget
          CalendarScreen(email: widget.userEmail),
          const ProfilePage(),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        //backgroundColor: const Color.fromRGBO(255, 242, 215, 1),
        //color: const Color.fromRGBO(28, 185, 14, 1),
        backgroundColor: Color.fromARGB(146, 255, 242, 215),
        //backgroundColor: const Color.fromRGBO(240, 255, 240, 1), // Light greenish background
        color: const Color(0xFF56AB2F), // Green gradient,
        height: 60,
        // letIndexChange: (index) => true,
        letIndexChange: (index) => index >= 0 && index < 5, // Allows the animation without repositioning the icon
        items: const <Widget>[
          Icon(
            Icons.home, 
            size: 35, 
            color: Colors.white
          ), // Homepage icon
          Icon(
            Icons.receipt_long, 
            size: 35, 
            color: Colors.white,
          ), // Receipts icon
          Icon(
            Icons.card_giftcard_rounded, 
            size: 35, 
            color: Colors.white,
          ), // Reward icon
          Icon(
            Icons.calendar_month_sharp, 
            size: 35, 
            color: Colors.white,
          ), // Calender icon
          Icon(
            Icons.person_2, 
            size: 35, 
            color: Colors.white,
          ), // Profile icon
        ],
        onTap: (index) {
          _onItemTapped(index);
        },
      ),
    );
  }
}
