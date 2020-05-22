import 'package:flutter/material.dart';
import 'package:sublin/screens/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:sublin/services/auth.dart';
import 'package:sublin/theme/theme.dart';
import './models/user.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sublin',
      theme: themeData,
      initialRoute: '/',
      // home: Wrapper(),
      routes: {
        '/': (context) => StreamProvider<User>.value(
            value: AuthService().user, child: Wrapper()),
      },
    );
  }
}
