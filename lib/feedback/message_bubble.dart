import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble(this.message, this.userName, this.isMe, {this.key});

  final Key key;
  final String message;
  final String userName;
  final bool isMe;

  @override
  Widget build(BuildContext context) {

    final _mediaQuery = MediaQuery.of(context).size;

    if(isMe){
      return Bubble(
        alignment: Alignment.topRight,
        color: Colors.blue,
        nip: BubbleNip.rightBottom,
        elevation: 2,
        margin: BubbleEdges.only(top: 10, right: 10,bottom: 5),
        child: Container(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width*0.75),
          child:
          Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: _mediaQuery.height*0.03, right: _mediaQuery.width*0.03,top: _mediaQuery.height*0.01, left: _mediaQuery.width*0.01),
                child: Text(message, style: GoogleFonts.lato(color: Colors.white,fontSize: 17),textAlign: TextAlign.start,),
              ),
              Positioned(right: 2, bottom: 2,child: Text("9:30am",style: TextStyle(color: Color(0xbfffffff), fontSize: 12),textAlign: TextAlign.end, ),)
            ],
          ),
        )
      );
    }else{
      return Bubble(
          alignment: Alignment.topLeft,
          color: Colors.white,
          nip: BubbleNip.leftBottom,
          elevation: 2,
          margin: BubbleEdges.only(top: 10, left: 10,bottom: 5),
          child: Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width*0.75),
            child:
            Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: _mediaQuery.height*0.03, right: _mediaQuery.width*0.03,top: _mediaQuery.height*0.01, left: _mediaQuery.width*0.01),
                  child: Text(message, style: GoogleFonts.lato(color: Colors.black,fontSize: 17),textAlign: TextAlign.start,),
                ),
                Positioned(right: 2, bottom: 2,child: Text("9:30am",style: TextStyle(color: Colors.black54, fontSize: 12),textAlign: TextAlign.end, ),)
              ],
            ),
          )
      );
    }

  }
}
