import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/rpg_awesome_icons.dart';
import 'package:fluttericon/zocial_icons.dart';
import 'package:nexus_sih/screens/circularScreen.dart';
import 'package:nexus_sih/screens/feedbackScreen.dart';
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
      'page': FeedbackScreen(),
      'title': 'Feedback',
    },
    {
      'page': NotificationScreen(),
      'title': 'Notification',
    },
    {
      'page': CircularScreen(),
      'title': 'Circulars',
    },
    {
      'page': ProfileScreen(),
      'title': 'Profile',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (currentIndex==0)?null:AppBar(
        title: Text(_pages[currentIndex]['title'], style: TextStyle(color: Colors.blue),),
        automaticallyImplyLeading: false,
        elevation: 8,
        backgroundColor: Colors.white,
      ),
      body: _pages[currentIndex]['page'],
      bottomNavigationBar: ConvexAppBar(
        items: [
          TabItem(icon: Icons.home, title: 'Home',),
          TabItem(icon: Icons.feedback, title: 'FeedBack'),
          TabItem(icon: Icons.notifications, title: 'Notification'),
          TabItem(icon: Icons.message, title: 'Circulars'),
          TabItem(icon: CupertinoIcons.profile_circled, title: 'Profile'),
        ],
        style: TabStyle.flip,
        height: 60,
        backgroundColor: Colors.white,
        color: Colors.black54,
        activeColor: Theme.of(context).primaryColor,
        top: -20,
        onTap: (index) => setState(() {
          currentIndex = index;
        }),
      )
//      CurvedNavigationBar(
//      backgroundColor: Color(0xfffff3f3),
//       height: 60,
//      items: <Widget>[
//        Icon(Icons.home, size: 25),
//        Icon(Icons.notifications, size: 25),
//        Icon(Icons.message, size: 25),
//        Icon(CupertinoIcons.profile_circled,size: 25,)
//      ],
//      onTap: (index) => setState(() {
//          currentIndex = index;
//        }),
//    ),

//      BottomNavyBar(
//        selectedIndex: currentIndex,
//        showElevation: true,
//        itemCornerRadius: 8,
//        curve: Curves.easeInBack,
//        containerHeight: MediaQuery.of(context).size.height*0.09,
//        iconSize:MediaQuery.of(context).size.height*0.04 ,
//        onItemSelected: (index) => setState(() {
//          currentIndex = index;
//        }),
//        items: [
//          BottomNavyBarItem(
//            icon: Icon(Icons.home),
//            title: Text('Home'),
//            activeColor: Color(0xffAC1D16),
//            inactiveColor: Color(0xfff7c4c2),
//            textAlign: TextAlign.center,
//          ),
//          BottomNavyBarItem(
//            icon: Icon(Icons.notifications),
//            title: Text('Notification'),
//            activeColor: Color(0xffAC1D16),
//            inactiveColor: Color(0xfff7c4c2),
//            textAlign: TextAlign.center,
//          ),
//          BottomNavyBarItem(
//            icon: Icon(Icons.blur_circular),
//            title: Text(
//              'Circular',
//            ),
//            activeColor: Color(0xffAC1D16),
//            inactiveColor: Color(0xfff7c4c2),
//          ),
//          BottomNavyBarItem(
//            icon: Icon(CupertinoIcons.profile_circled),
//            title: Text('Profile'),
//            activeColor: Color(0xffAC1D16),
//            inactiveColor: Color(0xfff7c4c2),
//          ),
//        ],
//      ),
    );
  }
}
