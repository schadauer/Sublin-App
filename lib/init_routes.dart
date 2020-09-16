import 'package:Sublin/screens/provider_scope_screen.dart';
import 'package:flutter/material.dart';
import 'package:Sublin/models/routing.dart';
import 'package:Sublin/models/user_type_enum.dart';
import 'package:Sublin/screens/provider_booking_screen.dart';
import 'package:Sublin/screens/provider_partner_screen.dart';
import 'package:Sublin/screens/provider_target_group_screen.dart';
import 'package:Sublin/screens/user_profile_screen.dart';
import 'package:Sublin/screens/user_my_sublin_screen.dart';
import 'package:Sublin/utils/is_route_completed.dart';
import 'package:provider/provider.dart';
import 'package:Sublin/models/provider_user.dart';
import 'package:Sublin/models/user_class.dart';
import 'package:Sublin/screens/email_list_screen.dart';
import 'package:Sublin/screens/provider_registration_screen.dart';
import 'package:Sublin/screens/user_routing_screen.dart';
import 'package:Sublin/theme/theme.dart';
import 'package:Sublin/widgets/loading_widget.dart';

class InitRoutes extends StatefulWidget {
  static const routeName = '/homeScreen';
  @override
  _InitRoutesState createState() => _InitRoutesState();
}

class _InitRoutesState extends State<InitRoutes> {
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
        ProviderBookingScreen.routeName: (context) => ProviderBookingScreen(),
        ProviderPartnerScreen.routeName: (context) => ProviderPartnerScreen(),
        ProviderTargetGroupScreen.routeName: (context) =>
            ProviderTargetGroupScreen(),
        ProviderScopeScreen.routeName: (context) => ProviderScopeScreen(),
        UserProfileScreen.routeName: (context) => UserProfileScreen(),
        UserMySublinScreen.routeName: (context) => UserMySublinScreen(),
        ProviderRegistrationScreen.routeName: (context) =>
            ProviderRegistrationScreen(),
        UserRoutingScreen.routeName: (context) => UserRoutingScreen(),
        EmailListScreen.routeName: (context) => EmailListScreen(),
      },
      title: 'Sublin',
      theme: themeData(context),
      home: (user.userType != UserType.user)
          ? providerUser.operationRequested
              ? ProviderBookingScreen()
              : ProviderRegistrationScreen()
          : routingService.booked == true && !isRouteCompleted(routingService)
              ? UserRoutingScreen(
                  setNavigationIndex: 1,
                )
              : UserMySublinScreen(
                  setNavigationIndex: 0,
                ),
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
