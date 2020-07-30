import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nexus_sih/widget/filterCircular.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'addCircular.dart';

class CircularScreen extends StatefulWidget {
  @override
  _CircularScreenState createState() => _CircularScreenState();
}

class _CircularScreenState extends State<CircularScreen>
    with SingleTickerProviderStateMixin {
  var dummyCircular = [
    {
      'circNo': 1,
      'subject': 'test subject',
      'organization': 'Bank of india',
      'Date': DateTime.now().toIso8601String()
    }
  ];
  Animation<double> _animation;
  AnimationController _animationController;
  IconData ic = Icons.add;
  var cbit = 1;
  var filterString =['All','Pension Reforms','Banking','Insurance'];
 final box=GetStorage();
  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    super.initState();
  }

  bool filter=false;
  var filtered;
  var sectornew='';
  var categorynew='';
  DateTime startDatenew,endDatenew;
  String currentFilter='';
  _circularDetails(List filterStrings) {
    setState(() {
      filterString=filterStrings;
      currentFilter=filterStrings[1];
    });
  }

  Widget textDisplay(String text, double size, FontWeight fweight) {
    return AutoSizeText(
      text,
      style: GoogleFonts.lato(
        textStyle:
            TextStyle(fontSize: size, letterSpacing: .5, fontWeight: fweight),
      ),
      textAlign: TextAlign.center,
      maxLines: 1,
      minFontSize: size,
      overflow: TextOverflow.ellipsis,
    );
  }
  Widget textDisplay2(String text, double size, FontWeight fweight) {
    return AutoSizeText(
      text,
      style: GoogleFonts.lato(
        textStyle:
        TextStyle(fontSize: size, letterSpacing: .5, fontWeight: fweight),
      ),
      textAlign: TextAlign.start,
      maxLines: 1,
      minFontSize: size,
      overflow: TextOverflow.ellipsis,
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
        stream: Firestore.instance
            .collection('circular')
            .where('category',whereIn: filterString)
            .orderBy('date', descending: true)
            .snapshots(),
        builder: (context, streamSnapshot) {
          if (streamSnapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(),
            );
          final documents = streamSnapshot.data.documents;
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
                child: InkWell(
                    onTap: (){},
                    child: Container(
                      height: height3 * 0.28,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Card(
                            elevation: 5,
                            child: Container(
                                height: height3 * 0.12,
                                width: width * 0.9,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
//                                    textDisplay(documents[index]['subject'], 20,
//                                        FontWeight.bold),
//                                    textDisplay(
//                                        'Section:' +
//                                            documents[index]['section'],
//                                        15,
//                                        FontWeight.normal),
                                    ListTile(
                                      leading: CircleAvatar(
                                        radius: height3*0.05,
                                        child: Text((index+1).toString()),
                                      ),
                                      title:  textDisplay2(documents[index]['subject'], 20,FontWeight.bold),
                                      subtitle:  textDisplay2(documents[index]['section'], 15,FontWeight.normal),
                                    )
                                  ],
                                )),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Card(
                                elevation: 2,
                                child: Container(
                                  height: height3 * 0.08,
                                  width: width * 0.4,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      textDisplay('Date', 15, FontWeight.bold),
                                      textDisplay(
                                          DateFormat('MMMM-dd, hh:mm').format(
                                              DateTime.fromMicrosecondsSinceEpoch(
                                                  documents[index]['date']
                                                      .microsecondsSinceEpoch)),
                                          15,
                                          FontWeight.normal),
                                    ],
                                  ),
                                ),
                              ),
                              Card(
                                elevation: 2,
                                child: Container(
                                  height: height3 * 0.08,
                                  width: width * 0.4,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      textDisplay(
                                          'Circular No:', 15, FontWeight.bold),
                                      textDisplay(
                                          documents[index]['circularNo'],
                                          15,
                                          FontWeight.normal),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Align(
                            alignment:Alignment.bottomRight,
                            child: Container(
                              margin: EdgeInsets.only(right: 10),
                              width: width*0.35,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(10)
                              ),
                              child: AutoSizeText(
                                documents[index]['category'],
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(
                                      fontSize: 15,
                                      letterSpacing: .5,
                                      fontWeight: FontWeight.normal,
                                  color: Colors.white),
                                ),
                                textAlign: TextAlign.end,
                                maxLines: 1,
                                minFontSize: 15,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )
                        ],
                      ),
                    )),
              );
            },
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      //Init Floating Action Bubble
      floatingActionButton: FloatingActionBubble(
        // Menu items
        items: <Bubble>[
          // Floating action menu item
          Bubble(
            title: "Filter",
            iconColor: Colors.white,
            bubbleColor: Theme.of(context).primaryColor,
            icon: FontAwesome5.filter,
            titleStyle: TextStyle(fontSize: 16, color: Colors.white),
            onPress: () {
              _animationController.reverse();
              showModalBottomSheet(
                  elevation: 10,
                  context: context,
                  builder: (BuildContext context) {
                    return FilterCircular(_circularDetails,currentFilter);
                  },
                  barrierColor: Colors.white.withOpacity(0),
                  shape: RoundedRectangleBorder(),
                  enableDrag: true,
                  backgroundColor: Colors.transparent,
              );
            },
          ),
          if(box.read('category')=='Tier-1')Bubble(
            title: "Post",
            iconColor: Colors.white,
            bubbleColor: Theme.of(context).primaryColor,
            icon: Icons.add,
            titleStyle: TextStyle(fontSize: 16, color: Colors.white),
            onPress: () {
              _animationController.reverse();
              Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => AddCircular(),
              ));
            },
          ),
          //Floating action menu item
        ],
        animation: _animation,
        onPress: () {
          _animationController.isCompleted
              ? _animationController.reverse()
              : _animationController.forward();
        },
        iconColor: Colors.blue,
        animatedIconData: AnimatedIcons.menu_close,
        backGroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
