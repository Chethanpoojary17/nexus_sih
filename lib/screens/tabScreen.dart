import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/rpg_awesome_icons.dart';
import 'package:fluttericon/zocial_icons.dart';
import 'package:google_fonts/google_fonts.dart';
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
  bool feedbit=false;
  var news='',fb='',circ='',noti='';
 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final fbm = FirebaseMessaging();
    fbm.requestNotificationPermissions();
    fbm.configure(onMessage:
        (Map<String, dynamic> message) async {
      setState(() {
        if(message['notification']['title']=='newsfeed')
        {news='New';}else if(message['notification']['title']=='feedback'){
          fb='New';
        }else if(message['notification']['title']=='notification'){
          noti='New';
        }else if(message['notification']['title']=='circular'){
          circ='New';
        }
      });
      print("onMessage: $message");
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Container(
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(message['notification']['title'],style: GoogleFonts.lato(textStyle: TextStyle(color:Colors.blue,fontSize: 20,fontWeight: FontWeight.bold)),textAlign: TextAlign.start,),
                Text(message['notification']['body'],style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 15,fontWeight: FontWeight.normal)),textAlign: TextAlign.start,)
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    }, onLaunch: (Map<String, dynamic> message) async {
      setState(() {
        if(message['notification']['title']=='newsfeed')
        {news='New';}else if(message['notification']['title']=='feedback'){
          fb='New';
        }else if(message['notification']['title']=='notification'){
          noti='New';
        }else if(message['notification']['title']=='circular'){
          circ='New';
        }
      });
    }, onResume: (Map<String, dynamic> message) async {
      setState(() {
        if(message['notification']['title']=='newsfeed')
        {currentIndex=2;}else if(message['notification']['title']=='feedback'){
          fb='New';
        }else if(message['notification']['title']=='notification'){
          noti='New';
        }else if(message['notification']['title']=='circular'){
          circ='New';
        }
      });
    });
    fbm.subscribeToTopic('chat');
 }

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
      bottomNavigationBar: ConvexAppBar.badge({0: news, 1: fb, 2: noti,3:circ},
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
        onTap: (index) {

          if(index==0){
            setState(() {
              news='';
            });
          }else if(index==1){
            setState(() {
              fb='';
            });
          }else if(index==2){
            setState(() {
              noti='';
            });
          }else if(index==3){
            setState(() {
              circ='';
            });
          }
        setState(() {
          currentIndex = index;
        });}
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
