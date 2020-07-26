import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:nexus_sih/screens/addNotification.dart';
import 'package:nexus_sih/screens/pdfViewer.dart';
import 'package:nexus_sih/widget/filterNotification.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool filter=false;
  Stream filtered;
  var organizationnew='';
  DateTime startDatenew,endDatenew;
  _filterItems(String subject,String organization,DateTime startDate,DateTime endDate){
    this.organizationnew=organization;
    this.startDatenew=startDate;
    this.endDatenew=endDate;
    Firestore.instance
        .collection('notification')
        .where('organization',whereIn: ['$organizationnew'])
        .snapshots().listen((event) {
          print(event.documents[0]['pdfUrl']);
    });
      print(organization.trim());
    setState(() {
      filter=true;
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

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var padding = MediaQuery.of(context).padding;
    double height3 = height - padding.top - kToolbarHeight;
    return Scaffold(
      body:(filter)?StreamBuilder(
        stream: Firestore.instance
            .collection('notification')
            .where('organization',whereIn: ["$organizationnew"])

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
              print(documents[index]['subject']);
              return Card(
                shadowColor: Theme.of(context).primaryColor,
                elevation: 5,
                margin: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 5,
                ),
                child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => PdfViewer(
                            title: documents[index]['subject'],
                            url: documents[index]['pdfUrl'],
                          )));
                    },
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
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    textDisplay(documents[index]['subject'], 20,
                                        FontWeight.bold),
                                    textDisplay(
                                        documents[index]['organization'],
                                        15,
                                        FontWeight.normal),
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
                                      textDisplay('Notification No:', 15,
                                          FontWeight.bold),
                                      textDisplay(
                                          documents[index]['notificationNo'],
                                          15,
                                          FontWeight.normal),
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
          );
        },
      ):StreamBuilder(
        stream: Firestore.instance
            .collection('notification')
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
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => PdfViewer(
                                title: documents[index]['subject'],
                                url: documents[index]['pdfUrl'],
                              )));
                    },
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    textDisplay(documents[index]['subject'], 20,
                                        FontWeight.bold),
                                    textDisplay(
                                        documents[index]['organization'],
                                        15,
                                        FontWeight.normal),
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
                                      textDisplay('Notification No:', 15,
                                          FontWeight.bold),
                                      textDisplay(
                                          documents[index]['notificationNo'],
                                          15,
                                          FontWeight.normal),
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
          );
        },
      ),

//      floatingActionButton: FloatingActionButton(
//        onPressed: () {
//          Navigator.of(context).push(MaterialPageRoute(
//            builder: (BuildContext context) => AddNotification(),
//          ));
//        },
//        child: Icon(
//          Icons.add,
//          color: Colors.white,
//        ),
//        backgroundColor: Theme.of(context).primaryColor,
//      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              elevation: 10,
              context: context,
              builder: (BuildContext context) {
                return FilterNotification(_filterItems);
              },
              barrierColor: Colors.white.withOpacity(0),
              shape: RoundedRectangleBorder(),
              enableDrag: true,
              backgroundColor: Colors.transparent);
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
