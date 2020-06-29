import 'package:flutter/material.dart';

ThemeData themeData(context) {
  return ThemeData(
    primarySwatch: Colors.blueGrey,
    primaryTextTheme: TextTheme(headline6: TextStyle(color: Colors.white)),
    primaryColor: Color.fromRGBO(54, 73, 88, 1),
    brightness: Brightness.light,
    accentColor: Colors.blueGrey[100],
    accentColorBrightness: Brightness.dark,
    splashColor: Color.fromRGBO(54, 73, 88, 1),
    buttonTheme: ButtonTheme.of(context).copyWith(
      buttonColor: Color.fromRGBO(59, 96, 100, 1),
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    ),
    dividerTheme: DividerThemeData(
      space: 70,
      thickness: 1,
      color: Theme.of(context).splashColor,
      indent: 20,
      endIndent: 20,
    ),
    canvasColor: Colors.white,
    inputDecorationTheme: InputDecorationTheme(
      fillColor: Color.fromRGBO(245, 245, 245, 1),
      filled: true,
      contentPadding: EdgeInsets.symmetric(vertical: 10),
      border: InputBorder.none,
      focusColor: Color.fromRGBO(230, 230, 230, 1),
      focusedBorder:
          OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
    ),
    backgroundColor: Color.fromRGBO(201, 228, 202, 1),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    textTheme: TextTheme(
      button: TextStyle(fontSize: 16),
      bodyText1: TextStyle(
        fontSize: 16,
        color: Colors.black,
        fontWeight: FontWeight.normal,
      ),
      bodyText2: TextStyle(
        fontSize: 16,
        color: Colors.black,
        fontWeight: FontWeight.normal,
      ),
      headline1: TextStyle(
        fontSize: 32,
        color: Colors.black,
        fontFamily: 'Open Sans',
        fontWeight: FontWeight.normal,
      ),
      headline2: TextStyle(
        fontSize: 28,
        color: Colors.black,
        fontWeight: FontWeight.normal,
        fontFamily: 'Open Sans',
      ),
      headline3: TextStyle(
        fontSize: 24,
        color: Colors.black,
        fontWeight: FontWeight.normal,
        fontFamily: 'Open Sans',
      ),
      headline4: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    fontFamily: 'Open Sans',
  );
}
