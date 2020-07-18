import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedpage/Loading.dart';
import 'package:feedpage/bookmarksService.dart';
import 'package:feedpage/user.dart';
import 'package:feedpage/userService.dart';
import 'package:feedpage/wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:feedpage/authService.dart';
import 'NavigationPage.dart';
import 'Profile.dart';
import 'PopUps/popUpProfilePage.dart';
import 'FeedBackForm.dart';
import 'package:feedpage/globals.dart' as globals;
import 'dart:async';

class Home extends StatefulWidget {
  User user;

  Home({this.user});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool one = false;
  bool two = false;
  bool three = false;
  var _timer;



  @override
  void initState() {
    if (!widget.user.isVerified) {
      Future(() async {
        _timer = Timer.periodic(Duration(seconds: 5), (timer) async {
          if (!widget.user.isVerified) {
            await FirebaseAuth.instance.currentUser()
              ..reload();
            var user = await FirebaseAuth.instance.currentUser();
            if (user.isEmailVerified) {
              setState(() {
                widget.user.isVerified = user.isEmailVerified;
              });
              timer.cancel();
            }
          }
          else{
            _timer.cancel();
          }
        });
      });
    }
    UserService currentUser = UserService(uid: widget.user.uid);
    currentUser.getData().then((result) {
      globals.currentUser = result;
      setState(() {
        three = true;
      });
    });
    bookmarksService book = bookmarksService(Uid: widget.user.uid);
    book.getData().then((result) {
      DocumentSnapshot data = result;
      if (data != null && data.exists) {
        globals.bookmarkUIDs = data.data['bookmarkUIDs'];
        globals.bookmarkFiles = data.data['bookmarkFiles'];
        globals.bookmarkStructure = data.data['bookmarkStructure'];
      } else {
        book.setInitialData();
      }
      setState(() {
        one = true;
      });
    });
    Firestore.instance
        .collection('watch_later')
        .document(widget.user.uid)
        .get()
        .then((value) {
      DocumentSnapshot data = value;
      if (data != null && data.exists) {
        globals.watchLaterUids = data.data['list'];
      }
      setState(() {
        two = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.user.isVerified) {
      print("yay");
      return AlertVerify(user: widget.user,);
    }
    else if (one && two && three && widget.user.isVerified) {
      return MaterialApp(
          title: 'User Profile Settings App',
          theme: ThemeData(
            scaffoldBackgroundColor: Color(0xffe1f4f3),
            primaryColor: Colors.black,
            //          iconTheme: IconThemeData(color: Colors.white),
          ),
          initialRoute: "/NavigationPage",
          routes: {
            "/NavigationPage": (context) => NavigationPage(),
            "/Profile": (context) => Profile(),
            "/PopUp": (context) => PopUpProfilePage(),
            "/Feedback": (context) => FeedbackForm(),
          });
    } else {
      return Loading();
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer.cancel();
    }
  }
}

class AlertVerify extends StatefulWidget {
  User user;
  AlertVerify({this.user});

  @override
  _AlertVerifyState createState() => _AlertVerifyState();
}

class _AlertVerifyState extends State<AlertVerify> {


  bool load = false;
  bool showSuccess = false;
  bool showFail = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: load?Center(
        child: Loading(),
      ): Container(
        child: ListView(
          children: <Widget>[
                    SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        'An email has been sent to your email address. Please verify to continue.',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        'Wait for up to 10 seconds after verifying.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                    showSuccess ?
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'An email has been sent.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                    ) : FlatButton(
                      textColor: Colors.blue,
                      child: Text(
                        'Click here to resend mail.',
                        style: TextStyle(fontSize: 10),
                      ),
                      onPressed: () async {
                        setState(() {
                          load = true;
                        });
                        try {
                          FirebaseAuth auth = FirebaseAuth.instance;
                          FirebaseUser u = await auth.currentUser();
                          await u.sendEmailVerification();
                          setState(() {
                            load = false;
                            showSuccess = true;
                          });
                        } catch (e) {
                          setState(() {
                            load = false;
                            showFail = true;
                          });
                        }
                      },
                    ),
                    showFail ? Text(
                      'Some error occurred.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.red,
                      ),
                    ) : Container(),

                FlatButton(
                  onPressed: () {
                    AuthService auth = AuthService();
                    auth.SignOut();
                    Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (context) => Wrapper()));
                  },
                  child: Text("Logout",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
            ]
            ),
      ),
    );
  }
}