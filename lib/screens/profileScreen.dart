import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nexus_sih/login/editProfile.dart';
import 'package:nexus_sih/login/styleSignin.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final box=GetStorage();
  _labelText(title) {
    return Padding(
      padding: EdgeInsets.only(left: 24),
      child: Text(
        title,
        style: GoogleFonts.lato(
            textStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            )
        )
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: StreamBuilder(
        stream: Firestore.instance.collection('Profile').where('userid',isEqualTo: box.read('currentUid')).snapshots(),
        builder: (context,streamSnapshot){
          if(streamSnapshot.connectionState==ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(),
            );
          final documents=streamSnapshot.data.documents;
          return SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height*1.15,
              child:Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height*0.01,
                  ),
               CircleAvatar(
                 radius: 70,
                 backgroundColor: Theme.of(context).primaryColor,
                 child: ClipOval(
                   child: new SizedBox(
                     width: 180.0,
                     height: 180.0,
                     child: (documents[0]['proPic'].toString().isEmpty) ? Icon(CupertinoIcons.profile_circled
                     ,size: 120,
                     ) : Image.network(documents[0]['proPic'],
                       fit: BoxFit.fill,
                     ),
                   ),
                 ),
               ),
               FlatButton.icon(onPressed: (){
                 Navigator.of(context).push(MaterialPageRoute(
                   builder: (BuildContext context) => EditProfile(
                     documents[0]['proPic'],
                     documents[0]['name'],
                     documents[0]['email'],
                     documents[0]['category'],
                     documents[0]['password'],
                     documents[0],
                   ),));
                }, icon: Icon(FontAwesome5.edit,color: Colors.white,), label: Text('Edit Profile',style: GoogleFonts.lato(
                 textStyle: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold)
               ),)),
                  Expanded(
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 32),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Theme.of(context).primaryColor, spreadRadius: 2, blurRadius: 3)
                        ],
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(50),
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 20),
                          _labelText('Name:'),
                          // _inputTextField('Enter your Full Name', false),
                          //
                          Container(
                            height: 56,
                            padding: EdgeInsets.fromLTRB(16, 3, 16, 6),
                            margin: EdgeInsets.all(8),
                            width: double.infinity,
                            alignment: Alignment.center,
                            decoration: raisedDecoration,
                            child: Text(documents[0]['name'],
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.normal,
                                )
                              )
                            ),
                          ),


                          SizedBox(height: 5),
                          _labelText('Email:'),
                          //_inputTextField('Enter your Email Id', false),
                          Container(
                            height: 56,
                            padding: EdgeInsets.fromLTRB(16, 3, 16, 6),
                            margin: EdgeInsets.all(8),
                            decoration: raisedDecoration,
                            child: Center(
                              child: Text(documents[0]['email'],
                                style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.normal,
                                    )
                                )
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          _labelText('Category:'),
                          //_inputTextField('Enter your Designation', false),
                          Container(
                            height: 56,
                            padding: EdgeInsets.fromLTRB(16, 3, 16, 6),
                            margin: EdgeInsets.all(8),
                            decoration: raisedDecoration,
                            alignment: Alignment.center,
                            child: Text(documents[0]['category'],
                              style: GoogleFonts.lato(
                                  textStyle: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.normal,
                                  )
                              )
                            ),
                          ),
                          SizedBox(height: 5),
                          _labelText('Designation:'),
                          //_inputTextField('Enter your Designation', false),
                          Container(
                            height: 56,
                            padding: EdgeInsets.fromLTRB(16, 3, 16, 6),
                            margin: EdgeInsets.all(8),
                            decoration: raisedDecoration,
                            alignment: Alignment.center,
                            child: Text(documents[0]['type'],
                                style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.normal,
                                    )
                                )
                            ),
                          ),
                          SizedBox(height: 5),
                          _labelText('Govt Id:'),
                          // _inputTextField('Enter your Govt Id', false),
                          Container(
                            height: 56,
                            padding: EdgeInsets.fromLTRB(16, 3, 16, 6),
                            margin: EdgeInsets.all(8),
                            decoration: raisedDecoration,
                            child: Center(
                              child: Text(documents[0]['govtid'],
                                style:GoogleFonts.lato(
                                    textStyle: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.normal,
                                    )
                                )
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Center(
                            child: Container(
                              height: 46,
                              width: 180,
                              child: RaisedButton(
                                onPressed: ()async{
                                  Alert(
                                    context: context,
                                    type: AlertType.warning,
                                    title: documents[0]['name'],
                                    desc: "Do you want to logout?",
                                    buttons: [
                                      DialogButton(
                                        child: Text(
                                          "Yes",
                                          style: TextStyle(color: Colors.white, fontSize: 20),
                                        ),
                                        onPressed: () async{
                                          var user= await FirebaseAuth.instance.signOut();
                                          box.erase();
                                          SystemNavigator.pop();},
                                        width: 120,color: Colors.blue,
                                      ),
                                      DialogButton(
                                        child: Text(
                                          "Cancel",
                                          style: TextStyle(color: Colors.white, fontSize: 20),
                                        ),
                                        onPressed: () => Navigator.of(context).pop(true),
                                        width: 120,
                                        color: Colors.blue,
                                      )
                                    ],
                                  ).show();
                                },
                                child: Text(
                                  'Log Out',
                                  style: GoogleFonts.lato(
                                      textStyle: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.normal,
                                      )
                                  )
                                ),
                                color: Theme.of(context).primaryColor,
                                textColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
