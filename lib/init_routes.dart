import 'package:Sublin/models/versioning_class.dart';
import 'package:Sublin/screens/test_period_screen.dart';
import 'package:Sublin/screens/waiting_screen.dart';
import 'package:Sublin/services/provider_user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Sublin/screens/provider_settings_screen.dart';
import 'package:Sublin/models/routing_class.dart';
import 'package:Sublin/models/user_type_enum.dart';
import 'package:Sublin/screens/provider_booking_screen.dart';
import 'package:Sublin/screens/provider_partner_screen.dart';
import 'package:Sublin/screens/provider_target_group_screen.dart';
import 'package:Sublin/screens/user_profile_screen.dart';
import 'package:Sublin/screens/user_my_sublin_screen.dart';
import 'package:Sublin/utils/is_route_completed.dart';
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
    final User user = Provider.of<User>(context);
    final Routing routingService = Provider.of<Routing>(context);
    final ProviderUser providerUser = Provider.of<ProviderUser>(context);

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
          ProviderSettingsScreen.routeName: (context) =>
              ProviderSettingsScreen(),
          UserProfileScreen.routeName: (context) => UserProfileScreen(),
          UserMySublinScreen.routeName: (context) => UserMySublinScreen(),
          ProviderRegistrationScreen.routeName: (context) =>
              ProviderRegistrationScreen(),
          UserRoutingScreen.routeName: (context) => UserRoutingScreen(),
          EmailListScreen.routeName: (context) => EmailListScreen(),
          TestPeriodScreen.routeName: (context) => TestPeriodScreen(),
        },
        title: 'Sublin',
        theme: themeData(context),
        home: FutureBuilder<List<ProviderUser>>(
            future: ProviderUserService()
                .getProvidersWithProviderPlanEmailOnly(email: user.email),
            builder: (BuildContext context,
                AsyncSnapshot<List<ProviderUser>> providerUserList) {
              if (providerUserList.hasData) {
                //* This is temporary as we need to restrict access for only
                //* permitted users and exclude sponsors
                return (user.isTestPeriodRegistrationCompleted == true ||
                        (providerUserList.data.length == 0 &&
                            user.userType == UserType.user))
                    ? TestPeriodScreen()
                    : (user.userType != UserType.user)
                        ? providerUser.operationRequested
                            ? ProviderBookingScreen()
                            : ProviderRegistrationScreen()
                        : routingService.booked == true &&
                                !isRouteCompleted(routingService)
                            ? UserRoutingScreen(
                                setNavigationIndex: 1,
                              )
                            : UserMySublinScreen(
                                setNavigationIndex: 0,
                              );
              } else {
                return WaitingScreen(
                  title: 'Sublin, auf geht\'s',
                );
              }
            }));
  }

  showProviderMenu() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Text('Appbar');
        });
  }

  bool _isValidVersion() {}
}
