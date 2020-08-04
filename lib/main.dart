import 'package:flutter/material.dart';
import 'package:Sublin/screens/auth_screen.dart';
import 'package:provider/provider.dart';
import 'package:Sublin/services/auth_service.dart';
import './models/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      StreamProvider<Auth>.value(value: AuthService().userStream),
    ], child: AuthScreen());
  }
}
