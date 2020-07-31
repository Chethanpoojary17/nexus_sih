import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nexus_sih/login/styles.dart';
import 'login_page.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  String name, category, email, govtid, password, phone,designation;

  final _text = TextEditingController();
  final db = Firestore.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _rememberMe = false;

  Widget _buildUsernameTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Username',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            keyboardType: TextInputType.text,
            validator: (value) {
              if ((value.isEmpty) || (value.length < 3)) {
                return "      Invalid username ";
              }
              return null;
            },
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.account_box,
                color: Colors.white,
              ),
              hintText: 'Enter your Name',
              hintStyle: kHintTextStyle,
            ),
            onChanged: (value) {
              this.name = value;
            },
          ),
        ),
      ],
    );
  }
  Widget _builddesignationTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Designation',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            keyboardType: TextInputType.text,
            validator: (value) {
              if ((value.isEmpty) || (value.length < 3)) {
                return "      Invalid designation ";
              }
              return null;
            },
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.account_box,
                color: Colors.white,
              ),
              hintText: 'Enter your Designation',
              hintStyle: kHintTextStyle,
            ),
            onChanged: (value) {
              this.designation = value;
            },
          ),
        ),
      ],
    );
  }


  Widget _buildUseridTF() {
    bool _validate = false;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'UserId',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            keyboardType: TextInputType.text,
            validator: (value) {
              if ((value.isEmpty) || (value.length < 5)) {
                return "      Invalid Userid ";
              }

              return null;
            },
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.account_circle,
                color: Colors.white,
              ),
              hintText: 'Enter your Govt.Id',
              hintStyle: kHintTextStyle,
            ),
            onChanged: (value) {
              this.govtid = value;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneTF() {
    bool _validate = false;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Phone Number',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            keyboardType: TextInputType.text,
            validator: (value) {
              if ((value.isEmpty) || (value.length < 10)) {
                return "      Invalid Phone Number ";
              }

              return null;
            },
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.account_circle,
                color: Colors.white,
              ),
              hintText: 'Enter your Phone Number',
              hintStyle: kHintTextStyle,
            ),
            onChanged: (value) {
              this.phone = value;
            },
          ),
        ),
      ],
    );
  }

  List<String> _category = ['Tier-1', 'Tier-2']; // Option 2
  String _selectedcategory;

  Widget _buildCategoryTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Category',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: DropdownButton(
            hint: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Text(
                'Please select',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'OpenSans',
                ),
              ),
            ), // Not necessary for Option 1
            value: _selectedcategory,
            onChanged: (newValue) {
              setState(() {
                _selectedcategory = newValue;
              });
            },
            items: _category.map((category) {
              return DropdownMenuItem(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: new Text(
                    category,
                    style: TextStyle(
                      color: Colors.black54,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                ),
                value: this.category = category,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Email Address',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              Pattern pattern =
                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
              RegExp regex = new RegExp(pattern);
              if (!regex.hasMatch(value)) {
                return "      Invalid email";
              }
              ;

              return null;
            },
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.white,
              ),
              hintText: 'Enter your Email Address',
              hintStyle: kHintTextStyle,
            ),
            onChanged: (value) {
              this.email = value;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Password',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            obscureText: true,
            validator: (value) {
              Pattern pattern =
                  r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
              RegExp regex = new RegExp(pattern);
              if (!regex.hasMatch(value)) {
                return "      Password not strong";
              }
              ;

              return null;
            },
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText: 'Enter your Password',
              hintStyle: kHintTextStyle,
            ),
            onChanged: (value) {
              this.password = value;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () async => {
          validateAndSubmit(),
          // await .instance.ve,
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'SIGNUP',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
  bool _isLoading = false;
  void validateAndSubmit() async {
    if (validateAndSave()) {
      setState(() {
        _isLoading=true;
      });
      try {
        AuthResult user = (await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: this.email, password: this.password));
        var url;
        if(_pickedImage!=null){final ref = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child(user.user.uid + '.jpg');
        await ref.putFile(_pickedImage).onComplete;
        url = await ref.getDownloadURL();}
        else{
          url='';
        }
        final fbm = FirebaseMessaging();
        var token=await fbm.getToken();
        await Firestore.instance.collection("Profile").document(user.user.uid).setData({
          'name': this.name.trim(),
          'email': this.email.trim(),
          'password': this.password.trim(),
          'govtid': this.govtid.trim(),
          'category': this._selectedcategory.trim(),
          'phone': this.phone,
          'userid': user.user.uid,
          'proPic':url,
          'type':designation,
          'token':token,
        });
        setState(() {
          _isLoading=false;
        });
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
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
        source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      _pickedImage = pickedImageFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                constraints: BoxConstraints.expand(),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                            "https://everything-pr.com/wp-content/uploads/2019/12/Government-of-India.jpg"),
                        fit: BoxFit.cover)),
              ),
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 120.0,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Sign In',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'OpenSans',
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 30.0),
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: (_pickedImage==null)?null:FileImage(_pickedImage),
                        ),
                        FlatButton.icon(
                            onPressed: _pickImage,
                            icon: Icon(
                              Icons.image,
                              color: Colors.white,
                            ),
                            label: Text(
                              'Choose image',
                              style: GoogleFonts.lato(
                                  textStyle: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                            )),
                        SizedBox(height: 30.0),
                        _buildUsernameTF(),
                        SizedBox(height: 30.0),
                        _buildUseridTF(),
                        SizedBox(height: 30.0),
                        _buildCategoryTF(),
                        SizedBox(
                          height: 30.0,
                        ),
                        _builddesignationTF(),
                        SizedBox(height: 30.0),
                        _buildEmailTF(),
                        SizedBox(height: 30.0),
                        _buildPasswordTF(),
                        // SizedBox(height: 30.0),
                        //_buildPhoneTF(),
                        (_isLoading)?CircularProgressIndicator():_buildLoginBtn(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
