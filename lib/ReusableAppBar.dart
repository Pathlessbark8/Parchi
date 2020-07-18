import 'package:flutter/material.dart';

AppBar ReusableAppBar() {
  return AppBar(
    elevation: 0,
    backgroundColor: Colors.lightBlue[700],
    centerTitle: true,
    title: Text(
      'PARCHI',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20.0,
        color: Colors.white,
        fontFamily: "Museo",
      ),
    ),
  );
}

