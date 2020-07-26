
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:polls/polls.dart';
class PollScreen extends StatefulWidget {
  @override
  _PollScreenState createState() => _PollScreenState();
}

class _PollScreenState extends State<PollScreen> {
  var user='sdkgjdf';
  var usersWhoVoted={};
  double fillheight;
  double fillwidth=0;
  var totalvotes=100;
  var ans1=10;
  var ans2=90;
  var answered=0;
  String percents1='';
  String percents2='';
  int selectedAns=0;
  var pollansid=[''],usrid=[''],anschoosen=[''];
  var answeredPoll=[''];
  var ansCheck={};
  @override
  void initState() {
    super.initState();
    getPollInfo();
  }

  getPollInfo() {
     Firestore.instance.collection('pollanswer').where('uid',isEqualTo: 'user1').snapshots().listen((event) {
           pollansid= List.generate(event.documents.length, (index) =>event.documents[index]['pollId']);
           usrid= List.generate(event.documents.length, (index) =>event.documents[index]['uid']);
          anschoosen=  List.generate(event.documents.length, (index) =>event.documents[index]['answer']);
           print(usrid);
           var i=0;
           pollansid.forEach((index) {
             ansCheck[index]=anschoosen[i];
             i+=1;
           });
           print(ansCheck['pollnew']);
    });

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
  DocumentSnapshot currentPoll;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var padding = MediaQuery.of(context).padding;
    double height3 = height - padding.top - kToolbarHeight;
    fillheight=height3*0.07;
    return Scaffold(
      body: StreamBuilder(stream: Firestore.instance.collection('poll').orderBy('date',descending: true).snapshots(),
        builder: (context,streamSnapshot){
          if(streamSnapshot.connectionState==ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(),
            );
          final documents=streamSnapshot.data.documents;
          var totalsum=0;
          var ans1sum=0;
          var ans2sum=0;
        return ListView.builder(itemCount: documents.length,itemBuilder: (context,index){
          totalsum=documents[index]['total'];
          ans1sum=documents[index]['ansAsum'];
          ans2sum=documents[index]['ansBsum'];
          currentPoll=documents[index];
          return Card(
            elevation: 5,
            child: Container(
              height: height3*0.3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  textDisplay(documents[index]['question'], 20, FontWeight.bold),
                  Stack(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(height3*0.01),
                        height: fillheight,
                        width: width*0.9,
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 1.0,color: Theme.of(context).primaryColor
                          ),
                          borderRadius: BorderRadius.all(
                              Radius.circular(30) //                 <--- border radius here
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(height3*0.01),
                        height: fillheight,
                        width: (!pollansid.contains(documents[index]['pollId']))?0:width*0.9*(ans1sum/totalsum),
                        decoration: BoxDecoration(
                          color: Theme.of(context).accentColor,

                          borderRadius: BorderRadius.all(
                              Radius.circular(30) //                 <--- border radius here
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          setState(() {
                            var batch =  Firestore.instance.batch();
                            var pollRef = Firestore.instance.collection("poll").document(documents[index]);
                            batch.updateData(pollRef,  {'total':documents[currentPoll]['total']+1});
                            batch.updateData(pollRef,  {'ansAsum':documents[currentPoll]['ansAsum']+1});
                            batch.updateData(pollRef,  {'ansBsum':documents[currentPoll]['ansBsum']+1});
                            batch.commit();
                            totalvotes+=1;
                            ans1+=1;
                            selectedAns=1;
                            percents1=((100*ans1sum)/totalsum).toStringAsFixed(0);
                            percents2=((100*ans2sum)/totalsum).toStringAsFixed(0);
                            answered=1;
                            fillwidth=1;
                          });
                        },
                        splashColor: Theme.of(context).accentColor,
                        child: Container(
                          margin: EdgeInsets.all(height3*0.01),
                          height: fillheight,
                          width: width*0.9,
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 1.0,color: Theme.of(context).primaryColor
                            ),
                            borderRadius: BorderRadius.all(
                                Radius.circular(30) //                 <--- border radius here
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding:  EdgeInsets.all(height3*0.015),
                                child: textDisplay(documents[index]['answerA'], 20, FontWeight.bold),
                              ),
                              if(selectedAns==1)
                                Image.asset('assets/images/rightmark.png',scale: 22,),
                              if(answered==1)
                                Padding(
                                  padding:  EdgeInsets.all(height3*0.015),
                                  child: textDisplay(percents1+'%', 20, FontWeight.bold),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(height3*0.01),
                        height: fillheight,
                        width: width*0.9,
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 1.0,color: Theme.of(context).primaryColor
                          ),
                          borderRadius: BorderRadius.all(
                              Radius.circular(30)
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(height3*0.01),
                        height: fillheight,
                        width: (answered==0)?0:width*0.9*(ans2/totalvotes),
                        decoration: BoxDecoration(
                          color: Theme.of(context).accentColor,

                          borderRadius: BorderRadius.all(
                              Radius.circular(30) //                 <--- border radius here
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          setState(() {
                            totalvotes+=1;
                            ans2+=1;
                            selectedAns=2;
                            percents1=((100*ans1)/totalvotes).toStringAsFixed(0);
                            percents1=((100*ans2)/totalvotes).toStringAsFixed(0);
                            answered=1;
                            fillwidth=1;
                          });
                        },
                        splashColor: Theme.of(context).accentColor,
                        child: Container(
                          margin: EdgeInsets.all(height3*0.01),
                          height: fillheight,
                          width: width*0.9,
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 1.0,color: Theme.of(context).primaryColor
                            ),
                            borderRadius: BorderRadius.all(
                                Radius.circular(30) //                 <--- border radius here
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding:  EdgeInsets.all(height3*0.015),
                                child: textDisplay(documents[index]['answerB'], 20, FontWeight.bold),
                              ),
                              if(selectedAns==2)
                                Image.asset('assets/images/rightmark.png',scale: 22,),
                              if(answered==1)
                                Padding(
                                  padding:  EdgeInsets.all(height3*0.015),
                                  child: textDisplay(percents2+'%', 20, FontWeight.bold),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
        },),
    );
  }
}
