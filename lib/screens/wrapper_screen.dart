import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sublin/models/routing.dart';
import 'package:sublin/screens/authenticate/authenticate_screen.dart';

import 'package:sublin/screens/routing_input_screen.dart';
import 'package:sublin/screens/routing_screen.dart';
import 'package:sublin/services/routing_service.dart';
import 'package:sublin/theme/theme.dart';

import '../models/user.dart';

class WrapperScreen extends StatelessWidget {
  static const routeName = '/wrapper';

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    if (user == null) {
      // If user is not logged in show Authentication screen
      return MaterialApp(
        theme: themeData(context),
        home: AuthenticateScreen(),
      );
    } else {
      return MultiProvider(
          providers: [
            StreamProvider<Routing>.value(
              initialData: Routing.initialData(),
              value: RoutingService().streamRouting(user.uid),
              lazy: false,
            )
          ],
          child: MaterialApp(
            title: 'Sublin',
            theme: themeData(context),
            home: RoutingInputScreen(),
            routes: {
              RoutingInputScreen.routeName: (context) => RoutingInputScreen(),
              RoutingScreen.routeName: (context) => RoutingScreen(),
            },
          ));
    }
  }
}
