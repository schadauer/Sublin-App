import 'package:flutter/material.dart';
import 'package:sublin/screens/authenticate/sign_in.dart';

class AuthenticateScreen extends StatefulWidget {
  @override
  _AuthenticateScreenState createState() => _AuthenticateScreenState();
}

class _AuthenticateScreenState extends State<AuthenticateScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: SignIn());
  }
}