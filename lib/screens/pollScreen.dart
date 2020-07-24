import 'package:auto_size_text/auto_size_text.dart';
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
    fillheight=height3*0.07;
    return Container(
      child: ListView.builder(itemCount: 3,itemBuilder: (context,index){
        return Card(
          elevation: 5,
          child: Container(
            height: height3*0.3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                textDisplay('This is poll question..', 20, FontWeight.bold),
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
                      width: (answered==0)?0:width*0.9*(ans1/totalvotes),
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
                          ans1+=1;
                          selectedAns=1;
                          percents1=((100*ans1)/totalvotes).toStringAsFixed(0);
                          percents2=((100*ans2)/totalvotes).toStringAsFixed(0);
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
                              child: textDisplay('Answer 2 ', 20, FontWeight.bold),
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
                            Radius.circular(30) //                 <--- border radius here
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
                              child: textDisplay('Answer 2 ', 20, FontWeight.bold),
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
      }),
    );
  }
}
