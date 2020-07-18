import 'dart:async';
import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'package:provider/provider.dart';
import 'user.dart';
import 'package:feedpage/home.dart';
import 'package:feedpage/authentication.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {

  var _timer;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if(!globals.assert_1){
      Future(() async {
        _timer = Timer.periodic(Duration(seconds: 5), (timer)  {
          setState(() {});
        });
    });
    }
    return user != null && globals.assert_1 ? Home(user: user,) : Authentication();
  }
}



