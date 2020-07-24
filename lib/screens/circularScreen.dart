import 'package:auto_size_text/auto_size_text.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/web_symbols_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hawk_fab_menu/hawk_fab_menu.dart';

class CircularScreen extends StatefulWidget {
  @override
  _CircularScreenState createState() => _CircularScreenState();
}

class _CircularScreenState extends State<CircularScreen>with SingleTickerProviderStateMixin{
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
  floatbutton(){
    setState(() {
      if(cbit==1){
        ic=Icons.clear;
      }
    });
  }

  _circularDetails(int circno) {
    print(circno);
  }
  Widget textDisplay(String text,double size,FontWeight fweight){
    return AutoSizeText(
      text,
      style: GoogleFonts.lato(
        textStyle: TextStyle(
          fontSize: size,
          letterSpacing: .5,
          fontWeight: fweight),
      ),
      textAlign: TextAlign.center,
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
          body: Column(
           children: <Widget>[
            Container(
              child: Expanded(
                child: ListView.builder(
                itemBuilder: (context, index) {
                  return Card(
                    shadowColor: Theme.of(context).primaryColor,
                    elevation: 5,
                    margin: EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 5,
                    ),
                    child: InkWell(
                        onTap: () => _circularDetails(index),
                        child: Container(
                          height: height3 * 0.25,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Card(
                                elevation: 5,
                                child: Container(
                                    height: height3 * 0.1,
                                    width: width * 0.9,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        textDisplay('This is subject', 20, FontWeight.bold),
                                        textDisplay('Section: AC', 15, FontWeight.normal),
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
                                          textDisplay('17-JUN-2020', 15, FontWeight.normal),
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
                                          textDisplay('Circular No:', 15, FontWeight.bold),
                                          textDisplay('17JUN-098', 15, FontWeight.normal),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              AutoSizeText(
                                'Category: Banking',
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(
                                      fontSize: 15,
                                      letterSpacing: .5,
                                      fontWeight: FontWeight.normal),
                                ),
                                textAlign: TextAlign.end,
                                maxLines: 1,
                                minFontSize: 15,
                                overflow: TextOverflow.ellipsis,
                              )
                            ],
                          ),
                        )),
                  );
                },
                itemCount: 10,
              ),
            ),
          ),
        ],
      ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

        //Init Floating Action Bubble
        floatingActionButton: FloatingActionBubble(
          // Menu items
          items: <Bubble>[
            // Floating action menu item
            Bubble(
              title:"Filter",
              iconColor :Colors.white,
              bubbleColor : Theme.of(context).primaryColor,
              icon:FontAwesome5.filter,
              titleStyle:TextStyle(fontSize: 16 , color: Colors.white),
              onPress: () {
                _animationController.reverse();
              },
            ),
            // Floating action menu item
            Bubble(
              title:"Post",
              iconColor :Colors.white,
              bubbleColor : Theme.of(context).primaryColor,
              icon:Icons.add,
              titleStyle:TextStyle(fontSize: 16 , color: Colors.white),
              onPress: () {
                _animationController.reverse();
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
