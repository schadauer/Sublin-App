import 'package:Sublin/models/routing.dart';
import 'package:Sublin/screens/provider_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Sublin/models/auth.dart';
import 'package:Sublin/models/provider_user.dart';
import 'package:Sublin/models/user.dart';
import 'package:Sublin/screens/email_list_screen.dart';
import 'package:Sublin/screens/provider_registration_screen.dart';
import 'package:Sublin/screens/user_home_screen.dart';
import 'package:Sublin/screens/user_routing_screen.dart';
import 'package:Sublin/theme/theme.dart';
import 'package:Sublin/widgets/loading_widget.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/homeScreen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    final user = Provider.of<User>(context);
    final providerUser = Provider.of<ProviderUser>(context);
    final Routing routingService = Provider.of<Routing>(context);

    if (user.streamingOn == false && providerUser.streamingOn == false)
      return MaterialApp(
        theme: themeData(context),
        home: Loading(),
      );
    return MaterialApp(
      routes: {
        HomeScreen.routeName: (context) => HomeScreen(),
        ProviderHomeScreen.routeName: (context) => ProviderHomeScreen(),
        UserHomeScreen.routeName: (context) => UserHomeScreen(),
        ProviderRegistrationScreen.routeName: (context) =>
            ProviderRegistrationScreen(),
        RoutingScreen.routeName: (context) => RoutingScreen(),
        EmailListScreen.routeName: (context) => EmailListScreen(),
      },
      title: 'Sublin',
      theme: themeData(context),
      home: (user.isProvider && !providerUser.inOperation)
          ? !providerUser.operationRequested
              ? ProviderRegistrationScreen()
              : ProviderHomeScreen()
          : routingService.booked != null && routingService.booked == true
              ? RoutingScreen()
              : UserHomeScreen(),
    );
  }

  showProviderMenu() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Text('Appbar');
        });
  }
}
