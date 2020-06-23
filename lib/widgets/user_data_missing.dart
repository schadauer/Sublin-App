import 'package:flutter/material.dart';

class UserDataMissing extends StatefulWidget {
  @override
  _UserDataMissingState createState() => _UserDataMissingState();
}

class _UserDataMissingState extends State<UserDataMissing> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Text('Hey, wir würden gerne noch was von dir wissen.'));
  }
}
