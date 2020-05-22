import 'package:flutter/material.dart';

var themeData = ThemeData(
  primaryColor: Color.fromRGBO(54, 73, 88, 1),
  accentColor: Color.fromRGBO(59, 96, 100, 1),
  splashColor: Color.fromRGBO(54, 73, 88, 1),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  textTheme: TextTheme(
    bodyText1: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
    headline1: TextStyle(
      fontSize: 10,
      color: Colors.white,
      fontFamily: 'Open Sans',
      fontWeight: FontWeight.bold,
    ),
    headline2: TextStyle(
      fontSize: 18,
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontFamily: 'Open Sans',
    ),
    headline3: TextStyle(
      fontSize: 16,
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontFamily: 'Open Sans',
    ),
    headline4: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
  ),
  fontFamily: 'Open Sans',
);
