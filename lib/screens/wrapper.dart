import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sublin/screens/authenticate/authenticate.dart';

import 'package:sublin/screens/home_screen.dart';

import '../models/user.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if (user == null) {
      //return HomeScreen();
      return Authenticate();
    } else {
      return HomeScreen();
    }
  }
}
