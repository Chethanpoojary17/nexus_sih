import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';

class NewMessage extends StatefulWidget {
  final toUid,toUname,toProfile;
  NewMessage(
      this.toUid,this.toUname,this.toProfile
      );
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final box=GetStorage();
  final _controller = new TextEditingController();
  var _enteredMessage ='';

  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    final user = await FirebaseAuth.instance.currentUser();
    final userData = await Firestore.instance.collection('Profile').where('userid',isEqualTo: user.uid).getDocuments();
    String chatid=user.uid+widget.toUid;
    Firestore.instance.collection('feedback').add({
      'content': _enteredMessage,
      'date': Timestamp.now(),
      'fromUid': user.uid,
      'fromName':box.read('currentUname'),
      'fromproPic':box.read('currentProfile'),
      'fromType':userData.documents[0]['type'],
      'toName':widget.toUname,
      'toUid':widget.toUid,
      'toproPic':widget.toProfile,
      'chatid':chatid.trim()
    });
    setState(() {
      _enteredMessage='';
    });

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              onSubmitted: (_)=> _enteredMessage.trim().isEmpty ? null : _sendMessage(),
              controller: _controller,
              decoration: InputDecoration(labelText: 'Send a message...'),
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
            ),
          ),
          IconButton(
            color: Theme.of(context).primaryColor,
            icon: Icon(
              Icons.send,
            ),
            onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
          )
        ],
      ),
    );
  }
}
