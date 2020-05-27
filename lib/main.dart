import 'package:flutter/material.dart';
import 'package:sublin/screens/wrapper_screen.dart';
import 'package:provider/provider.dart';
import 'package:sublin/services/auth_service.dart';
import 'package:sublin/theme/theme.dart';
import './models/user.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User>.value(value: AuthService().user),
      ],
      child: MaterialApp(
        title: 'Sublin',
        theme: themeData(context),
        home: WrapperScreen(),
        routes: {
          WrapperScreen.routeName: (context) => WrapperScreen(),
        },
      ),
    );
  }
}
