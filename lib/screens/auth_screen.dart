import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Sublin/models/provider_user.dart';
import 'package:Sublin/models/routing.dart';
import 'package:Sublin/models/user.dart';
import 'package:Sublin/screens/authenticate/authenticate_screen.dart';
import 'package:Sublin/screens/home_screen.dart';
import 'package:Sublin/services/provider_user_service.dart';
import 'package:Sublin/services/routing_service.dart';
import 'package:Sublin/services/user_service.dart';
import 'package:Sublin/theme/theme.dart';

import '../models/auth.dart';

class AuthScreen extends StatelessWidget {
  static const routeName = '/wrapper';

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Auth>(context);

    if (user == null) {
      // If user is not logged in show Authentication screen
      return MaterialApp(
        theme: themeData(context),
        home: AuthenticateScreen(),
      );
    } else {
      return MultiProvider(providers: [
        StreamProvider<Routing>.value(
          initialData: Routing(),
          value: RoutingService().streamRouting(user.uid),
          lazy: true,
        ),
        StreamProvider<User>.value(
          initialData: User.initialData(),
          value: UserService().streamUser(user.uid),
          lazy: true,
        ),
        StreamProvider<ProviderUser>.value(
          initialData: ProviderUser(),
          value: ProviderService().streamProviderUserData(user.uid),
          lazy: true,
        )
      ], child: HomeScreen());
    }
  }
}
