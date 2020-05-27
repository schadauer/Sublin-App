import 'package:flutter/material.dart';

ThemeData themeData(context) {
  return ThemeData(
    primaryColor: Color.fromRGBO(54, 73, 88, 1),
//primarySwatch: Color.lerp(a, b, t),
    accentColor: Color.fromRGBO(59, 96, 100, 1),
    accentColorBrightness: Brightness.dark,
    splashColor: Color.fromRGBO(54, 73, 88, 1),
    buttonTheme: ButtonTheme.of(context).copyWith(
      buttonColor: Color.fromRGBO(59, 96, 100, 1),
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    ),

    inputDecorationTheme: InputDecorationTheme(
      fillColor: Colors.black12,
      filled: true,
      contentPadding: EdgeInsets.symmetric(vertical: 15),
      border: InputBorder.none,
      focusedBorder:
          OutlineInputBorder(borderRadius: BorderRadius.circular(0.0)),
    ),

    backgroundColor: Color.fromRGBO(201, 228, 202, 1),
    visualDensity: VisualDensity.adaptivePlatformDensity,

    textTheme: TextTheme(
      button: TextStyle(fontSize: 16),
      bodyText1: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
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
}
