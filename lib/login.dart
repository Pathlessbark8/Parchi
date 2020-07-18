import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:feedpage/authService.dart';
import 'package:feedpage/loading.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email = '';
  String password = '';
  String error = '';
  String username = '';
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  bool obs = true;

  Future<void> _showMyDialog() async {
    AuthService _auth = AuthService();
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Forgot Password?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
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
                  onChanged: (val) {
                    setState(() => email = val);
                  },
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  'An email will be sent to this email address.',
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Submit'),
              onPressed: () {
                _auth.ResetPassword(email);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();
    if (loading) {
      return Loading();
    } else {
      return Scaffold(
        body: Padding(
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
                  "Login",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                  ),
                ),
              ),
              SizedBox(height: 40.0),
              TextFormField(
                autofocus: false,
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
                validator: (val) => val.isEmpty ? 'Enter your Email' : null,
                onChanged: (val) {
                  setState(() => email = val.trim());
                },
              ),
              SizedBox(height: 40.0),
              TextFormField(
                obscureText: obs,
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
                          obs = !obs;
                        });
                      },
                      child: obs == true
                          ? Icon(Icons.visibility)
                          : Icon(Icons.visibility_off)),
                  labelText: 'password *',
                ),
                validator: (val) => val.length < 8
                    ? 'Enter a password 8 characters long'
                    : null,
                onChanged: (val) {
                  setState(() => password = val);
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
                            'Sign In',
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

                          dynamic result = await _auth.signIn(email, password);

                          setState(() {
                            if (result == null) {
                              error = 'Some error occurred';
                            }
                            loading = false;
                          });
                        }
                      })),
              SizedBox(
                height: 10.0,
              ),
              FlatButton(
                textColor: Colors.blue,
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(fontSize: 13),
                ),
                onPressed: () {
                  _showMyDialog();
                },
              ),
              SizedBox(height: 10),
              Container(
                  alignment: Alignment.center,
                  child: Text('--------------------Or--------------------',
                      style: TextStyle(color: Colors.grey[400]))),
              SizedBox(height: 10),
              Container(
                alignment: Alignment.center,
                child: OutlineButton(
                  splashColor: Colors.grey,
                  onPressed: () async {
                    setState(() {
                      loading = true;
                    });
                    var result = await _auth.gSignIn();
                    if (result == null) {
                      setState(() {
                        loading = false;
                        error = "Some error occurred";
                      });
                    }
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40)),
                  highlightElevation: 0,
                  borderSide: BorderSide(color: Colors.grey[600]),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image(
                          image: AssetImage("assets/google.png"), height: 28.0),
                      SizedBox(width: 5),
                      Text(
                        'Sign in with Google',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
              Container(
                child: Row(
                  children: <Widget>[
                    Text('Do not have account?'),
                    FlatButton(
                      textColor: Colors.blue,
                      child: Text(
                        'Register',
                        style: TextStyle(fontSize: 15),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/register');
                      },
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
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
        backgroundColor: Colors.grey[100],
      );
    }
  }
}
