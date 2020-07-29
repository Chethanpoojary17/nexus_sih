import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
class PostPoll extends StatefulWidget {
  @override
  _PostPollState createState() => _PostPollState();
}

class _PostPollState extends State<PostPoll> {
  final box=GetStorage();
  var currentUid;
  var question='',ans1='',ans2='';
  bool _validate=false;
  bool _isLoading=false;
  void _post() async{
      setState(() {
        (question.isEmpty || ans1.isEmpty || ans2.isEmpty)?_validate=true:_validate=false;
      });
      if(!_validate){
        try {
          List list = List.generate(18, (i) => i);
          list.shuffle();
          String pollId = question.substring(0, 5) + list[0].toString();
          currentUid=box.read('currentUid');
          await Firestore.instance.collection('poll').add({
            'question': question.trim(),
            'answerA': ans1.trim(),
            'answerB': ans2.trim(),
            'ansAsum': 0,
            'ansBsum': 0,
            'total': 0,
            'date': Timestamp.now(),
            'pollId': pollId.trim(),
            'creator':currentUid,
          });
          Navigator.of(context).pop(true);
        }on PlatformException catch (err) {
          var message = 'An error occurred, please check your credentials!';

          if (err.message != null) {
            message = err.message;
          }
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: Theme.of(context).errorColor,
            ),
          );
          setState(() {
            _isLoading = false;
          });
          Navigator.of(context).pop(true);
        } catch (err) {
          print(err);
          setState(() {
            _isLoading = false;
          });
        }
      }
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          top: 10,
          left: MediaQuery.of(context).size.width*0.06,
          right: MediaQuery.of(context).size.width*0.06,
          bottom: MediaQuery.of(context).viewInsets.bottom + 10,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft:  Radius.circular(30),topRight:  Radius.circular(30)
          ),
        ),
        child: Column(
          children: <Widget>[
            Text('Create New Poll',style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),),
            SizedBox(height: 10,),
            TextField(
              minLines: 1,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: 'Question/Statement',
                hintText: 'Enter the Question/Statement',
                errorText: _validate ? 'Value Can\'t Be Empty' : null,
              ),
              onChanged: (value){
                question=value;
              },
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Option A',
                hintText: 'Enter option A',
                errorText: _validate ? 'Value Can\'t Be Empty' : null,
              ),
              onChanged: (value){
                ans1=value;
              },
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Option B',
                hintText: 'Enter option B',
                errorText: _validate ? 'Value Can\'t Be Empty' : null,
              ),
              onChanged: (value){
                ans2=value;
              },
            ),
            (_isLoading)?CircularProgressIndicator():RaisedButton(
              onPressed: _post,
              child: Text('Post',style:TextStyle(color: Colors.white)),
              color: Theme.of(context).primaryColor,
            )
          ],
        ),
      ),
    );
  }
}
