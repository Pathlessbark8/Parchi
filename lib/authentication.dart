import 'package:flutter/material.dart';
import 'package:feedpage/login.dart';
import 'package:feedpage/register.dart';

class Authentication extends StatefulWidget {
  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xffe1f4f3),
        primaryColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => Login(),
        '/register': (context) => Register(),
      },
    );
  }
}
