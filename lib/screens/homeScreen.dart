import 'package:flutter/material.dart';
import 'package:fluttericon/brandico_icons.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/fontelico_icons.dart';
import 'package:fluttericon/modern_pictograms_icons.dart';
import 'package:fluttericon/zocial_icons.dart';
import 'package:nexus_sih/screens/feedScreen.dart';
import 'package:nexus_sih/screens/pollScreen.dart';
import 'package:nexus_sih/screens/twitterScreen.dart';
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  int pageindex=3;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: pageindex,
      initialIndex: 1,
      child: Scaffold(
        appBar:new PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: new Container(
            color: Theme.of(context).primaryColor,
            child: new SafeArea(
              child: Column(
                children: <Widget>[
                  new Expanded(child: new Container()),
                    TabBar(
                     tabs: [
                             Tab(icon: Icon(FontAwesome5.poll),),
                             Tab(icon: Icon(FontAwesome5.newspaper)),
                             Tab(icon: Icon(Brandico.twitter_bird)),
                           ],
                         ),
                       ],
                    ),
                  ),
                ),
              ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            PollScreen(),
            FeedScreen(),
            TwitterScreen(),
          ],
        ),
      ),
    );
  }
}
