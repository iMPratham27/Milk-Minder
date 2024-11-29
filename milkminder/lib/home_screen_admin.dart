import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:milkminder/admin_home.dart';
import 'package:milkminder/profile_admin.dart';
import 'package:milkminder/rewardspageadmin.dart';
import 'package:milkminder/user_list.dart';


class AdminHomeScreen extends StatefulWidget {
  final String userEmail;

  const AdminHomeScreen({super.key, required this.userEmail});

  @override
  State createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State{
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
        children:  const [
          AdminPage(),
          UserListPage(),
          AdminRewardsPage(),
          AdminProfilePage(),
        ],
      ),
     bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: const Color(0xFFF4F8FB),
        color: const Color.fromRGBO(58,123,213, 1),
        height: 60,
        letIndexChange: (index) => true, // Allows the animation without repositioning the icon
        items: const <Widget>[
          
          //Home icon
          Icon(
            Icons.home, 
            size: 35, 
            color: Colors.white
          ),
          
          //user-list icon
          Icon(
            Icons.assignment, 
            size: 35, 
            color: Colors.white
          ),
          
          //add-rewards icon
          Icon(
            Icons.card_giftcard_rounded, 
            size: 35, 
            color: Colors.white
          ),
          
          //admin-profile icon
          Icon(
            Icons.admin_panel_settings_rounded, 
            size: 35, 
            color: Colors.white
          ),
        ],
        
        onTap: (index) {
          _onItemTapped(index);
        },
      ),
    );
  }
}
