import 'dart:io';
import 'package:get_storage/get_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  final String propic, email, name, category, password;
  final DocumentSnapshot doc;
  EditProfile(this.propic, this.name, this.email, this.category, this.password,this.doc);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final box=GetStorage();
  var name = '', propic = '', email = '', category = '';
  bool _validate=false;
  bool _isLoading=false;
   void updateProfile() async{
//     var user= await FirebaseAuth.instance.currentUser();
//     print(user.uid);
     setState(() {
       if(name.isEmpty || email.isEmpty || category.isEmpty)
         _validate=true;
       else
         _validate=false;
     });
     if(!_validate){
       setState(() {
         _isLoading=true;
       });
       try{
       var user= await FirebaseAuth.instance.signInWithEmailAndPassword(email: widget.email, password: widget.password);
       user.user.updateEmail(email);
       var url;
       if(_pickedImage!=null){final ref = FirebaseStorage.instance
           .ref()
           .child('user_image')
           .child(user.user.uid + '.jpg');
       await ref.putFile(_pickedImage).onComplete;
       url = await ref.getDownloadURL();}
       else{
         url=widget.propic;
       }
       box.write('currentUname', this.name.trim());
       box.write('currentProfile', this.name.trim());
       box.write('category', this.category.trim());
       widget.doc.reference.updateData({'name': this.name.trim(),
         'email': this.email.trim(),
         'category': this.category.trim(),
         'proPic':url,});
//       await Firestore.instance.collection("Profile").document(user.user.uid).updateData({
//         'name': this.name.trim(),
//         'email': this.email.trim(),
//         'category': this.category.trim(),
//         'proPic':url,
//         'password':widget.password,
//         'govtid':'sss'
//       });
       setState(() {
         _isLoading=false;
       });
      Navigator.of(context).pop(true);
     } catch (e) {
     setState(() {
     _isLoading=false;
     });
     print('error $e');
     }
     }
   }
  File _pickedImage;
  void _pickImage() async {
    final pickedImageFile = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 60);
    setState(() {
      _pickedImage = pickedImageFile;
    });
  }
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.7;
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Profile'),
        ),
        body: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(height*0.03),
              child: CircleAvatar(
                radius: 70,
                backgroundColor: Color(0xFF311B92),
                child: ClipOval(
                  child: new SizedBox(
                    width: 180.0,
                    height: 180.0,
                    child: (widget.propic.isEmpty)
                        ? Icon(
                            CupertinoIcons.profile_circled,
                            size: 120,
                          )
                        : (_pickedImage!=null)?Image.file(_pickedImage):Image.network(
                            widget.propic,
                            fit: BoxFit.fill,
                          ),
                  ),
                ),
              ),
            ),
            FlatButton.icon(onPressed: _pickImage, icon: Icon(Icons.camera,color:Theme.of(context).primaryColor,), label: Text('Change Profile Image',style:GoogleFonts.lato(
                textStyle: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold)) ,)),
            Expanded(
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Color(0x80c62828),
                        spreadRadius: 2,
                        blurRadius: 3)
                  ],
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(50),
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      SizedBox(height: 20),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Name',
                          icon: Icon(Icons.title),
                          errorText: _validate ? 'Value Can\'t Be Empty' : null,
                        ),
                        onChanged: (value) {
                          name = value;
                        },
                      ),
                      SizedBox(height: 20),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Email',
                          icon: Icon(Icons.email),
                          errorText: _validate ? 'Value Can\'t Be Empty' : null,
                        ),
                        onChanged: (value) {
                          email = value;
                        },
                      ),
                      SizedBox(height: 20),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Category',
                          icon: Icon(Icons.category),
                          errorText: _validate ? 'Value Can\'t Be Empty' : null,
                        ),
                        onChanged: (value) {
                          category = value;
                        },
                      ),
                      SizedBox(height: 20),
                      (_isLoading)?CircularProgressIndicator():RaisedButton.icon(
                        onPressed:updateProfile,
                        icon: Icon(
                          Icons.save,
                          color: Colors.white,
                        ),
                        label: Text(
                          "Save",
                          style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                        ),
                        color: Theme.of(context).primaryColor,
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
