import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/rpg_awesome_icons.dart';
import 'package:fluttericon/zocial_icons.dart';
import 'package:nexus_sih/screens/circularScreen.dart';
import 'package:nexus_sih/screens/homeScreen.dart';
import 'package:nexus_sih/screens/notificationScreen.dart';
import 'package:nexus_sih/screens/profileScreen.dart';
class TabScreen extends StatefulWidget {
  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  int currentIndex = 0;
  final List<Map<String, Object>> _pages = [
    {
      'page': HomeScreen(),
      'title': 'Home',
    },
    {
      'page': NotificationScreen(),
      'title': 'Notification',
    },
    {
      'page': CircularScreen(),
      'title': 'Circular',
    },
    {
      'page': ProfileScreen(),
      'title': 'Profile',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DFS'),
      ),
      body: _pages[currentIndex]['page'],
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: currentIndex,
        showElevation: true,
        itemCornerRadius: 8,
        curve: Curves.easeInBack,
        containerHeight: MediaQuery.of(context).size.height*0.09,
        iconSize:MediaQuery.of(context).size.height*0.04 ,
        onItemSelected: (index) => setState(() {
          currentIndex = index;
        }),
        items: [
          BottomNavyBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
            activeColor: Color(0xffAC1D16),
            inactiveColor: Color(0xfff7c4c2),
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.notifications),
            title: Text('Notification'),
            activeColor: Color(0xffAC1D16),
            inactiveColor: Color(0xfff7c4c2),
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.blur_circular),
            title: Text(
              'Circular',
            ),
            activeColor: Color(0xffAC1D16),
            inactiveColor: Color(0xfff7c4c2),
          ),
          BottomNavyBarItem(
            icon: Icon(CupertinoIcons.profile_circled),
            title: Text('Profile'),
            activeColor: Color(0xffAC1D16),
            inactiveColor: Color(0xfff7c4c2),
          ),
        ],
      ),
    );
  }
}
