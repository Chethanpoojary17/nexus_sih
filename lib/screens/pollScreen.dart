import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nexus_sih/widget/postPoll.dart';
import 'package:get_storage/get_storage.dart';


class PollScreen extends StatefulWidget {
  @override
  _PollScreenState createState() => _PollScreenState();
}

class _PollScreenState extends State<PollScreen> {
  List<String> pollansid, anschoosen;
  Map<String, String> ansCheck = {};
  var totalsum = 0;
  var ans1sum = 0;
  var ans2sum = 0;
  String pollId = '';
  final box=GetStorage();
  var currentUid='';
  @override
  void initState() {
    super.initState();
    getPollInfo();
  }

  getPollInfo() {

    currentUid=box.read('currentUid');
    print(currentUid);
    Firestore.instance
        .collection('pollanswer')
        .where('uid', isEqualTo: currentUid)
        .snapshots()
        .listen((event) {
      pollansid = List.generate(
          event.documents.length, (index) => event.documents[index]['pollId']);
      anschoosen = List.generate(
          event.documents.length, (index) => event.documents[index]['answer']);
      var i = 0;
      pollansid.forEach((index) {
        ansCheck[index] = anschoosen[i];
        i += 1;
      });
      print(anschoosen);
      print(ansCheck);
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    Widget _getPollAnswer(String title, double percentage, String answer) {
      bool val = title == answer;
      return Card(
        shadowColor: val ? Theme.of(context).primaryColor : Colors.grey,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {},
              child: Container(
                width: val ? width * 0.8 : width * 0.78,
                height: height * 0.06,
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        color: val ? Colors.green : Colors.red,
                        width: width * 0.8 * percentage / 100,
                        height: double.infinity,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.06),
                      child: Align(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              title,
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              "${percentage.round()}%",
                              style: GoogleFonts.lato(
                                  textStyle: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    Widget _getPollOption(String title, DocumentSnapshot doc, String option) {
      return Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                doc.reference.updateData(
                    {option: doc[option] + 1, 'total': doc['total'] + 1});
                Firestore.instance.collection('pollanswer').add(
                    {'answer': title, 'pollId': doc['pollId'], 'uid': currentUid});
                ansCheck[doc['pollId']] = title;
              },
              child: Container(
                width: width * 0.8,
                height: height * 0.06,
                alignment: Alignment.center,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    title,
                    style: GoogleFonts.lato(
                      textStyle:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    Widget _getPollCard(String question, String ansA, String ansB,
        double ansAPer, double ansBPer, bool code, DocumentSnapshot doc) {
      return Card(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: height * 0.02),
          child: Column(
            children: [
              Text(
                question,
                style: GoogleFonts.lato(
                  textStyle:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              code
                  ? Column(
                      children: [
                        _getPollAnswer(ansA, ansAPer, ansCheck[doc['pollId']]),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        _getPollAnswer(ansB, ansBPer, ansCheck[doc['pollId']]),
                      ],
                    )
                  : Column(
                      children: [
                        _getPollOption(ansA, doc, 'ansAsum'),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        _getPollOption(ansB, doc, 'ansBsum'),
                      ],
                    )
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: StreamBuilder(
        stream: Firestore.instance
            .collection('poll')
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
                totalsum = documents[index]['total'];
                ans1sum = documents[index]['ansAsum'];
                ans2sum = documents[index]['ansBsum'];
                pollId = documents[index]['pollId'];

                print(documents);
                bool code = ansCheck.containsKey(pollId);
                return _getPollCard(
                    documents[index]['question'],
                    documents[index]['answerA'],
                    documents[index]['answerB'],
                    ans1sum * 100 / totalsum,
                    ans2sum * 100 / totalsum,
                    code,
                    documents[index]);
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            elevation: 5,
              barrierColor: Colors.white.withOpacity(0),
              shape: RoundedRectangleBorder(),
              enableDrag: true,
              backgroundColor: Colors.transparent,
              context: context,
              builder: (BuildContext context) {
                return PostPoll();
              });
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor:Theme.of(context).primaryColor,
      ),
    );
  }
}
