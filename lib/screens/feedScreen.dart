import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/maki_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:nexus_sih/screens/postFeed.dart';
import 'package:nexus_sih/screens/webView.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> with SingleTickerProviderStateMixin{

  Animation<double> _animation;
  AnimationController _animationController;
  IconData ic=Icons.add;
  var cbit=1;

  @override
  void initState(){

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );

    final curvedAnimation = CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    super.initState();


  }
  Widget textDisplay(String text, double size, FontWeight fweight,
      TextAlign align, int mlines) {
    return Padding(
      padding: EdgeInsets.all(6),
      child: AutoSizeText(
        text,
        style: GoogleFonts.lato(
          textStyle:
              TextStyle(fontSize: size, letterSpacing: .5, fontWeight: fweight),
        ),
        textAlign: align,
        maxLines: mlines,
        minFontSize: size,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var padding = MediaQuery.of(context).padding;
    double height3 = height - padding.top - kToolbarHeight;
    return Scaffold(
      body: StreamBuilder(
        stream: Firestore.instance.collection('newsfeed').orderBy('Time',descending: true).snapshots(),
        builder: (context, streamSnapshot) {
          if(streamSnapshot.connectionState==ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(),
            );
          final documents=streamSnapshot.data.documents;
          return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                return Card(
                  shadowColor: Theme.of(context).primaryColor,
                  elevation: 5,
                  margin: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 5,
                  ),
                  child: Container(
                    height: height3 * 0.7,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Card(
                          elevation: 3,
                          child: Container(
                            height: height3 * 0.1,
                            width: width * 1,
                            child: ListTile(
                              contentPadding: EdgeInsets.all(4),
                              leading: CircleAvatar(
                                radius: 30.0,
                                backgroundImage: NetworkImage(
                                    documents[index]['proPic']),
                                backgroundColor: Colors.transparent,
                              ),
                              title: textDisplay(documents[index]['name'], 20, FontWeight.bold,
                                  TextAlign.start, 1),
                            ),
                          ),
                        ),
                        (documents[index]['type'])?
                        Container(
                          height: height3 * 0.4,
                          width: width * 1,
                          child: Image.network(
                            documents[index]['content'],
                            fit: BoxFit.fitWidth,
                          ),
                        ):
                        Container(
                          height: height3 * 0.4,
                          width: width * 1,
                          child: Center(
                            child: Linkify(
                              onOpen: (link) async {
                                {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) => MyWebView(
                                        title: documents[index]['Title'],
                                        selectedUrl: link.url,
                                      )));
                                }
                              },
                              text: documents[index]['content'],
                              style: GoogleFonts.lato(
                                textStyle:
                                TextStyle(fontSize: 20, letterSpacing: .5, fontWeight: FontWeight.normal),
                              ),
                              textAlign: TextAlign.center,
                              linkStyle: TextStyle(color: Colors.red),
                            ),
                          ),
                        ),
                        textDisplay(documents[index]['Title'], 18, FontWeight.bold,
                            TextAlign.start, 1),
                        textDisplay(
                            documents[index]['Description'],
                            15,
                            FontWeight.normal,
                            TextAlign.start,
                            2),
                        textDisplay(DateFormat('MMMM-dd, hh:mm').format(DateTime.fromMicrosecondsSinceEpoch(documents[index]['Time'].microsecondsSinceEpoch)), 12, FontWeight.normal,
                            TextAlign.center, 1)
                      ],
                    ),
                  ),
                );
              });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      //Init Floating Action Bubble
      floatingActionButton: FloatingActionBubble(
        // Menu items
        items: <Bubble>[
          // Floating action menu item
          Bubble(
            title:"Text/URL",
            iconColor :Colors.white,
            bubbleColor : Theme.of(context).primaryColor,
            icon:Icons.text_fields,
            titleStyle:TextStyle(fontSize: 16 , color: Colors.white),
            onPress: () {
              _animationController.reverse();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => PostFeed(
                   typePost: 'Text',
                  ),));
            },
          ),
          // Floating action menu item
          Bubble(
            title:"Photo",
            iconColor :Colors.white,
            bubbleColor : Theme.of(context).primaryColor,
            icon:Icons.photo_library,
            titleStyle:TextStyle(fontSize: 16 , color: Colors.white),
            onPress: () {
              _animationController.reverse();
              Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => PostFeed(
                  typePost: 'Photo',
                ),));
            },
          ),
          //Floating action menu item
        ],
        animation: _animation,
        onPress: () {
          _animationController.isCompleted
              ? _animationController.reverse()
              : _animationController.forward();},
        iconColor: Colors.blue,
        animatedIconData:AnimatedIcons.menu_close,
        backGroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
