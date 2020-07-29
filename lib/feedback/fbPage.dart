import 'package:flutter/material.dart';
import 'package:nexus_sih/feedback/messages.dart';
import 'package:nexus_sih/feedback/new_message.dart';
class FBMessages extends StatefulWidget {
  final name,proPic,uid;
  FBMessages(
      this.uid,this.proPic,this.name
      );
  @override
  _FBMessagesState createState() => _FBMessagesState();
}

class _FBMessagesState extends State<FBMessages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            CircleAvatar(
              backgroundImage: NetworkImage(widget.proPic,),
            ),
            SizedBox(width: 20,),
            Text(widget.name)
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Messages(
                widget.uid,widget.name,widget.proPic
              ),
            ),
            NewMessage(
              widget.uid,widget.name,widget.proPic
            ),
          ],
        ),
      ),
    );
  }
}
