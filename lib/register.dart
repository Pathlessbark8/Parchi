import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:feedpage/authService.dart';
import 'package:feedpage/loading.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String email = '';
  String password = '';
  String password1 = '';
  String username = '';
  String error = '';
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  bool obs1 = true;
  bool obs2 = true;

  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();

    if (loading) {
      return Loading();
    } else {
      return Scaffold(
        backgroundColor: Colors.grey[100],
        body: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0),
              child: Form(
                key: _formKey,
                child: ListView(children: <Widget>[
                  SizedBox(height: 40.0),
                  Center(
                      child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                        height: 120, child: Image.asset("assets/AppLogo.png")),
                  )),
                  SizedBox(height: 40.0),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      "Register",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 26,
                      ),
                    ),
                  ),
                  SizedBox(height: 40.0),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Type your email',
                      hintStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white70,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        borderSide: BorderSide(color: Colors.grey, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      icon: Icon(Icons.email),
                      labelText: 'email *',
                    ),
                    validator: (val) => val.isEmpty ? 'Enter an email' : null,
                    onChanged: (val) {
                      setState(() => email = val.trim());
                    },
                  ),
                  SizedBox(height: 40.0),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Enter an username',
                      hintStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white70,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        borderSide: BorderSide(color: Colors.grey, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      icon: Icon(Icons.person),
                      labelText: 'username *',
                    ),
                    validator: (val) => val.isEmpty ? 'Enter a username' : null,
                    onChanged: (val) {
                      setState(() => username = val.trim());
                    },
                  ),
                  SizedBox(height: 40.0),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Type your password',
                      hintStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white70,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        borderSide: BorderSide(color: Colors.grey, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      icon: Icon(Icons.lock),
                      suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              obs1 = !obs1;
                            });
                          },
                          child: obs1 == true
                              ? Icon(Icons.visibility)
                              : Icon(Icons.visibility_off)),
                      labelText: 'password *',
                    ),
                    obscureText: obs1,
                    validator: (val) => val.length < 8
                        ? 'Enter a password 8 characters long'
                        : null,
                    onChanged: (val) {
                      setState(() => password = val);
                    },
                  ),
                  SizedBox(height: 40.0),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Type your password again',
                      hintStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white70,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        borderSide: BorderSide(color: Colors.grey, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      icon: Icon(Icons.lock),
                      suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              obs2 = !obs2;
                            });
                          },
                          child: obs2 == true
                              ? Icon(Icons.visibility)
                              : Icon(Icons.visibility_off)),
                      labelText: 'confirm password *',
                    ),
                    obscureText: obs2,
                    validator: (val) =>
                        password == password1 ? null : 'Passwords don\'t match',
                    onChanged: (val) {
                      setState(() => password1 = val);
                    },
                  ),
                  SizedBox(height: 40.0),
                  Container(
                    alignment: Alignment.center,
                    child: RaisedButton(
                        color: Colors.blue,
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Sign Up',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17.0,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            setState(() {
                              loading = true;
                            });
                            dynamic result =
                                await _auth.register(email, password, username);
                            if (result == null) {
                              setState(() {
                                error = 'Some error occurred';
                                loading = false;
                              });
                            }
                            if (result == 1) {
                              setState(() {
                                error = 'Username already taken';
                                loading = false;
                              });
                            }
                          }
                        }),
                  ),
                  SizedBox(height: 12),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      error,
                      style: TextStyle(color: Colors.red, fontSize: 14.0),
                    ),
                  ),
                ]),
              ),
            ),
            Positioned(
              top: 40,
              left: 15,
              child: ButtonTheme(
                height: 30,
                minWidth: 50,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
