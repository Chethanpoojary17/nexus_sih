import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
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
    return Column(
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
                                      textDisplay('Organization: Bank of india', 15, FontWeight.normal),
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
                                        textDisplay('Date:', 15, FontWeight.bold),
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
                                        textDisplay('Notification No:', 15, FontWeight.bold),
                                        textDisplay('17JUN-098', 15, FontWeight.normal),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
    );
  }
}
