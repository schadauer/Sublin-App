import 'package:flutter/material.dart';

ThemeData themeData(context) {
  return ThemeData(
    primarySwatch: Colors.blueGrey,
    primaryTextTheme: TextTheme(headline6: TextStyle(color: Colors.white)),
    // primaryColor: Color.fromRGBO(54, 73, 88, 1),
    primaryColor: Color.fromRGBO(216, 214, 204, 1),
    secondaryHeaderColor: Color.fromRGBO(0, 174, 99, 0.6),
    brightness: Brightness.light,
    accentColor: Colors.blueGrey[100],
    accentColorBrightness: Brightness.dark,
    splashColor: Color.fromRGBO(3, 174, 99, 1),
    buttonTheme: ButtonTheme.of(context).copyWith(
      buttonColor: Color.fromRGBO(0, 133, 74, 1),
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
    errorColor: Colors.red[400],
    inputDecorationTheme: InputDecorationTheme(
      fillColor: Color.fromRGBO(245, 245, 245, 1),
      filled: true,
      contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      border: OutlineInputBorder(),
      focusColor: Color.fromRGBO(230, 230, 230, 1),
      focusedBorder:
          OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
    ),
    backgroundColor: Color.fromRGBO(201, 228, 202, 1),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    // appBarTheme: AppBarTheme(textTheme: TextTh),
    textTheme: TextTheme(
      caption: TextStyle(
        fontSize: 14,
        fontFamily: 'Lato',
        color: Colors.black,
      ),
      button: TextStyle(
        fontSize: 16,
        fontFamily: 'Lato',
        color: Colors.black,
        fontWeight: FontWeight.normal,
      ),
      bodyText1: TextStyle(
        fontSize: 16,
        fontFamily: 'Lato',
        color: Colors.black,
        fontWeight: FontWeight.normal,
      ),
      bodyText2: TextStyle(
        fontSize: 16,
        color: Colors.black,
        fontWeight: FontWeight.normal,
      ),
      headline1: TextStyle(
        fontSize: 18,
        color: Colors.black,
        fontFamily: 'Lato',
        fontWeight: FontWeight.bold,
      ),
      headline2: TextStyle(
        fontSize: 16,
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontFamily: 'Lato',
      ),
      headline3: TextStyle(
        fontSize: 20,
        color: Colors.black,
        fontWeight: FontWeight.normal,
        fontFamily: 'Open Sans',
      ),
      headline4: TextStyle(
        fontSize: 16,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    ),
    fontFamily: 'Open Sans',
  );
}
