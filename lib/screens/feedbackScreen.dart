import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:nexus_sih/feedback/fbPage.dart';

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final box = GetStorage();
  var feedbacksnap;
  List<String> uname=[], upropic=[], uid=[], utype=[];

  getUsers() async {
    if (box.read('category') == 'Tier 1') {
      Firestore.instance
          .collection('feedback')
          .where('toUid', isEqualTo: box.read('currentUid'))
          .orderBy('date', descending: true)
          .snapshots().listen((event) {
        uid = List.generate(
            event.documents.length, (index) => event.documents[index]['fromUid']);
        uname = List.generate(
            event.documents.length, (index) => event.documents[index]['fromName']);
        upropic = List.generate(event.documents.length,
                (index) => event.documents[index]['fromproPic']);
        utype = List.generate(
            event.documents.length, (index) => event.documents[index]['fromType']);
        uid = uid.toSet().toList();
        uname = uname.toSet().toList();
        upropic = upropic.toSet().toList();
        utype = utype.toSet().toList();
        print(uid);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream:Firestore.instance
            .collection('Profile')
            .where('category', isEqualTo: 'Tier-1')
            .snapshots(),
        builder: (context, streamSnapshot) {
          if (streamSnapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(),
            );
          final documents = streamSnapshot.data.documents;
          return (box.read('category') == 'Tier-2')
              ? ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(5),
                      child: ListTile(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) => FBMessages(
                                  documents[index]['userid'],
                                  documents[index]['proPic'],
                                  documents[index]['name'])));
                        },
                        contentPadding: EdgeInsets.only(
                            right: 10, top: 5, bottom: 5, left: 5),
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(
                            documents[index]['proPic'],
                          ),
                        ),
                        title: Text(
                          documents[index]['name'],
                          style: GoogleFonts.lato(
                              textStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          )),
                        ),
                        subtitle: Text(
                          documents[index]['type'],
                          style: GoogleFonts.lato(
                              textStyle: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                          )),
                        ),
                      ),
                    );
                  })
              :(uid.isEmpty)?Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Lottie.asset('assets/images/empty.json'),
                  Text('No FeedBacks..',style: GoogleFonts.lato( fontSize: 20,),)
                ],
              ): ListView.builder(
                  itemCount: uid.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(5),
                      child: ListTile(
                        onTap: () {
                          print(uid.elementAt(index));
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) => FBMessages(
                                  uid.elementAt(index),
                                  upropic.elementAt(index),
                                  uname.elementAt(index))));
                        },
                        contentPadding: EdgeInsets.only(
                            right: 10, top: 5, bottom: 5, left: 5),
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(
                            upropic.elementAt(index),
                          ),
                        ),
                        title: Text(
                          uname.elementAt(index),
                          style: GoogleFonts.lato(
                              textStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          )),
                        ),
                        subtitle: Text(
                          utype.elementAt(index),
                          style: GoogleFonts.lato(
                              textStyle: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                          )),
                        ),
                      ),
                    );
                  });
        });
  }
}
