import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sublin/screens/authenticate/authenticate.dart';

import 'package:sublin/screens/home_screen.dart';

import 'package:sublin/services/routing_service.dart';
import '../models/user.dart';
import '../models/routing.dart';

class WrapperScreen extends StatelessWidget {
  static const routeName = '/wrapper';

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if (user == null) {
      //return HomeScreen();
      return Authenticate();
    } else {
      return MultiProvider(providers: [
        StreamProvider<Routing>.value(
            value: RoutingService().streamRouting(user.uid)),
      ], child: HomeScreen());
    }
  }
}
