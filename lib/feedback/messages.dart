import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:nexus_sih/feedback/message_bubble.dart';
class Messages extends StatefulWidget {
  final toUid,toName,toProfile;
  Messages(
      this.toUid,this.toName,this.toProfile
      );
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  final box=GetStorage();
  var chatid;
  @override
  Widget build(BuildContext context) {
    chatid=[box.read('currentUid')+widget.toUid,widget.toUid+box.read('currentUid')];
    print(chatid);
    return  StreamBuilder(
            stream: Firestore.instance
                .collection('feedback').where('chatid',whereIn:chatid)
                .orderBy(
                  'date',
                  descending: true,
                )
                .snapshots(),
            builder: (ctx, chatSnapshot) {
              if (chatSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final chatDocs = chatSnapshot.data.documents;
              return (chatDocs.isEmpty)?Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Lottie.asset('assets/images/empty.json'),
                  Text('Send any suggestion or Feedback',style: GoogleFonts.lato( fontSize: 20,),)
                ],
              ):ListView.builder(
                reverse: true,
                itemCount: chatDocs.length,
                itemBuilder: (ctx, index) => MessageBubble(
                  chatDocs[index]['content'],
                  chatDocs[index]['fromName'],
                  chatDocs[index]['fromUid'] == box.read(('currentUid')),
                  key: ValueKey(chatDocs[index].documentID),
                ),
              );
            });
  }
}
