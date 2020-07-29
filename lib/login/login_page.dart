
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nexus_sih/login/signup.dart';
import 'package:nexus_sih/login/styles.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:nexus_sih/screens/tabScreen.dart';
import 'package:get_storage/get_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email, password;
  final GlobalKey<FormState> formk = GlobalKey<FormState>();
  bool _rememberMe = false;

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
            keyboardType: TextInputType.text,
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
                Icons.account_circle,
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

  String warning;
  Widget _buildForgotPasswordBtn() {
    return Container(
      alignment: Alignment.centerRight,
      child: FlatButton(
        onPressed: () async => {
          await FirebaseAuth.instance.sendPasswordResetEmail(email: email),
          Alert(
            context: context,
            type: AlertType.info,
            title: "Password reset",
            desc: "Password reset link is sent to $email",
            buttons: [
              DialogButton(
                child: Text(
                  "OK",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () => Navigator.pop(context),
                width: 120,
              )
            ],
          ).show()
        },
        padding: EdgeInsets.only(right: 0.0),
        child: Text(
          'Forgot Password?',
          style: kLabelStyle,
        ),
      ),
    );
  }

  Widget _buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        //onPressed: () => Navigator.push(
        //  context, MaterialPageRoute(builder: (context) => Home())),
        onPressed: () {
          validateAndSubmit();
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'LOGIN',
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
    final form = formk.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
bool _isLoading=false;
  void validateAndSubmit() async {
    if (validateAndSave()) {
      setState(() {
        _isLoading=true;
      });
      FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: this.email, password: this.password)
          .then((signedInUser) async{
            final box=GetStorage();
           final info=await Firestore.instance.collection('Profile').where('userid',isEqualTo:signedInUser.user.uid ).getDocuments();
           print(info.documents[0]['name']);
            box.write('currentUid', signedInUser.user.uid);
            box.write('currentUname', info.documents[0]['name']);
            box.write('currentProfile', info.documents[0]['proPic']);
            box.write('category', info.documents[0]['category']);
            print(box.read('currentUid'));
          Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => TabScreen(),));
      setState(() {
        _isLoading=false;
      });
      }).catchError((e) {
        print(e);
        setState(() {
          _isLoading=false;
        });
      });
    }
  }

  Widget _buildSignupBtn() {
    return GestureDetector(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => SignupScreen())),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Don\'t have an Account? ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Sign Up',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
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
                    //Image.asset('assets/images/img.jpg'),
                    image: DecorationImage(
//                        image: new AssetImage('assets/img.jpg'),
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
                    key: formk,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'OpenSans',
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 30.0),
                        _buildEmailTF(),
                        SizedBox(
                          height: 30.0,
                        ),
                        _buildPasswordTF(),
                        _buildForgotPasswordBtn(),
                        //_buildRememberMeCheckbox(),
                        (_isLoading)?CircularProgressIndicator():_buildLoginBtn(),
                        _buildSignupBtn(),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
