import 'package:flutter/material.dart';
import 'package:Sublin/models/routing.dart';
import 'package:Sublin/models/user_type.dart';
import 'package:Sublin/screens/provider_booking_screen.dart';
import 'package:Sublin/screens/provider_partner_screen.dart';
import 'package:Sublin/screens/provider_target_group_screen.dart';
import 'package:Sublin/screens/user_profile_screen.dart';
import 'package:Sublin/screens/user_free_ride_screen.dart';
import 'package:Sublin/utils/is_route_completed.dart';
import 'package:provider/provider.dart';
import 'package:Sublin/models/provider_user.dart';
import 'package:Sublin/models/user.dart';
import 'package:Sublin/screens/email_list_screen.dart';
import 'package:Sublin/screens/provider_registration_screen.dart';
import 'package:Sublin/screens/user_home_screen.dart';
import 'package:Sublin/screens/user_routing_screen.dart';
import 'package:Sublin/theme/theme.dart';
import 'package:Sublin/widgets/loading_widget.dart';

class RoutingScreen extends StatefulWidget {
  static const routeName = '/homeScreen';
  @override
  _RoutingScreenState createState() => _RoutingScreenState();
}

class _RoutingScreenState extends State<RoutingScreen> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final Routing routingService = Provider.of<Routing>(context);
    final providerUser = Provider.of<ProviderUser>(context);

    if (user.streamingOn == false && providerUser.streamingOn == false)
      return MaterialApp(
        theme: themeData(context),
        home: Loading(),
      );
    return MaterialApp(
      routes: {
        // HomeScreen.routeName: (context) => HomeScreen(),
        ProviderBookingScreen.routeName: (context) => ProviderBookingScreen(),
        ProviderPartnerScreen.routeName: (context) => ProviderPartnerScreen(),
        ProviderTargetGroupScreen.routeName: (context) =>
            ProviderTargetGroupScreen(),
        UserHomeScreen.routeName: (context) => UserHomeScreen(),
        UserProfileScreen.routeName: (context) => UserProfileScreen(),
        UserFreeRideScreen.routeName: (context) => UserFreeRideScreen(),
        ProviderRegistrationScreen.routeName: (context) =>
            ProviderRegistrationScreen(),
        UserRoutingScreen.routeName: (context) => UserRoutingScreen(),
        EmailListScreen.routeName: (context) => EmailListScreen(),
      },
      title: 'Sublin',
      theme: themeData(context),
      home: (user.userType != UserType.user && !providerUser.inOperation)
          ? providerUser.operationRequested
              ? ProviderBookingScreen()
              : ProviderRegistrationScreen()
          : routingService.booked == true && !isRouteCompleted(routingService)
              ? UserRoutingScreen()
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
