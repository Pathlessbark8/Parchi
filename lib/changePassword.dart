import 'package:feedpage/NavigationPage.dart';
import 'package:flutter/material.dart';
import 'package:feedpage/authService.dart';
import 'package:feedpage/Loading.dart';
import 'package:feedpage/globals.dart' as globals;

class VerifyPassword extends StatefulWidget {
  @override
  _VerifyPasswordState createState() => _VerifyPasswordState();
}

class _VerifyPasswordState extends State<VerifyPassword> {
  String oldPassword = "";
  bool loading = false;
  String error = "";
  AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[400],
          title: Center(child: Text('Verify your password')),
        ),
        backgroundColor: Colors.blue[50],
        body: Padding(
            padding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0),
            child: Form(
                key: _formKey,
                child: ListView(children: [
                  Container(
                    alignment: Alignment.center,
                    child: TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.lock),
                        labelText: 'Old Password',
                      ),
                      validator: (val) => val.length < 8
                          ? 'Enter a password 8 characters long'
                          : null,
                      onChanged: (val) {
                        setState(() => oldPassword = val);
                      },
                    ),
                  ),
                  SizedBox(height: 50),
                  Center(
                    child: RaisedButton(
                        color: Colors.pink[400],
                        child: Text(
                          'Continue',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            setState(() {
                              loading = true;
                            });
                            dynamic result = await _auth.signIn(
                                globals.currentUser.email, oldPassword);
                            if (result == null) {
                              setState(() {
                                error = 'Password is incorrect';
                                loading = false;
                              });
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChangePassword()));
                            }
                          }
                        }),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      error,
                      style: TextStyle(color: Colors.red, fontSize: 14.0),
                    ),
                  ),
                ]))));
  }
}

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool loading = false;
  String error = "";
  AuthService _auth = AuthService();
  String newPassword = "";
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return loading == true
        ? Loading()
        : SafeArea(
            child: Scaffold(
              appBar: AppBar(),
              body: Padding(
                padding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: TextFormField(
                          obscureText: true,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.lock),
                            labelText: 'New Password',
                          ),
                          validator: (val) => val.length < 8
                              ? 'Enter a password 8 characters long'
                              : null,
                          onChanged: (val) {
                            setState(() => newPassword = val);
                          },
                        ),
                      ),
                      Center(
                        child: TextFormField(
                          obscureText: true,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.lock),
                            labelText: 'Retype New Password',
                          ),
                          validator: (val) => val.length < 8
                              ? 'Enter a password 8 characters long'
                              : null,
                          onChanged: (val) {
                            setState(() => newPassword = val);
                          },
                        ),
                      ),
                      SizedBox(height: 40),
                      Center(
                        child: RaisedButton(
                            color: Colors.pink[400],
                            child: Text(
                              'Change Password',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                setState(() {
                                  loading = true;
                                });
                                dynamic result =
                                    await _auth.ChangePassword(newPassword);
                                setState(() {
                                  loading = false;
                                });
                                if (result == null) {
                                  error = 'Passwords Don\'t match';
                                } else {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => NavigationPage()));
                                }
                              }
                            }),
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          error,
                          style: TextStyle(color: Colors.red, fontSize: 14.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
