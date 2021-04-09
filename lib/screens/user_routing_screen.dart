import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:provider/provider.dart';
import 'package:Sublin/screens/user_show_routing_screen.dart';
import 'package:Sublin/screens/waiting_screen.dart';
import 'package:Sublin/utils/is_route_confirmed.dart';
import 'package:Sublin/models/preferences_enum.dart';
import 'package:Sublin/models/user_class.dart';
import 'package:Sublin/models/user_type_enum.dart';
import 'package:Sublin/screens/user_my_sublin_screen.dart';
import 'package:Sublin/services/routing_service.dart';
import 'package:Sublin/services/shared_preferences_service.dart';
import 'package:Sublin/utils/is_route_completed.dart';
import 'package:Sublin/widgets/appbar_widget.dart';
import 'package:Sublin/widgets/navigation_bar_widget.dart';
import 'package:Sublin/models/routing_class.dart';
import 'user_routing_no_route_screen.dart';

class UserRoutingScreen extends StatefulWidget {
  const UserRoutingScreen({Key key, this.setNavigationIndex}) : super(key: key);
  final int setNavigationIndex;
  static const routeName = '/userRoutingScreen';
  @override
  _UserRoutingScreenState createState() => _UserRoutingScreenState();
}

class _UserRoutingScreenState extends State<UserRoutingScreen> {
  // Timer _timer;
  int currentTime = DateTime.now().millisecondsSinceEpoch;

  @override
  Widget build(BuildContext context) {
    final Routing routingService = Provider.of<Routing>(context);
    final User user = Provider.of<User>(context);
    double heightBookingBottomSheet = 70.0;

    final Routing screenArguments =
        ModalRoute.of(context).settings.arguments as Routing;

    bool _isRouteAvailable() {
      bool startAddressIsAvailable =
          routingService.startAddressAvailable == true &&
                  routingService.isPubliclyAccessibleStartAddress == false ||
              routingService.startAddressAvailable == false &&
                  routingService.isPubliclyAccessibleStartAddress == true;
      bool endAddressIsAvailable = routingService.endAddressAvailable == true &&
              routingService.isPubliclyAccessibleEndAddress == false ||
          routingService.endAddressAvailable == false &&
              routingService.isPubliclyAccessibleEndAddress == true;
      bool bothAddressesareNotSublin = !routingService.endAddressAvailable &&
          !routingService.startAddressAvailable;
      return startAddressIsAvailable == true &&
          endAddressIsAvailable == true &&
          !bothAddressesareNotSublin;
    }

    bool _isRouteExpired() {
      int startTime = routingService.isPubliclyAccessibleStartAddress
          ? routingService.publicSteps[1].startTime
          : routingService.sublinStartStep.startTime;
      if (startTime * 1000 > DateTime.now().millisecondsSinceEpoch)
        return false;
      else
        return true;
    }

    return FutureBuilder<List<String>>(
        future: Future.wait([
          getStringValuesSF(Preferences.stringLocalRequestStartAddress),
          getStringValuesSF(Preferences.stringLocalRequestEndAddress),
        ]),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (isRouteConfirmed(routingService) && _isRouteAvailable()) {
              return UserShowRoutingScreen(
                  user: user,
                  routingService: routingService,
                  heightBookingBottomSheet: heightBookingBottomSheet);
            }
            if (snapshot.data[0] == routingService.startAddress &&
                snapshot.data[1] == routingService.endAddress) {
              if (!_isRouteAvailable()) {
                return Scaffold(
                    appBar: AppbarWidget(title: 'Meine Fahrt'),
                    body: UserRoutingNoRouteScreen(
                      user: user,
                      icon: Icon(
                        Icons.sentiment_dissatisfied,
                        size: 50,
                      ),
                      title: 'Nicht verfügbar',
                      text: 'Leider ist deine Route nicht verfügbar.',
                      buttonText: 'Zu meinen Shuttles',
                    ));
              } else if (_isRouteExpired()) {
                return Scaffold(
                    // appBar: AppbarWidget(title: 'Abgelaufene Fahrt'),
                    body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 300),
                        child: AutoSizeText(
                          'Deine Route ist abgelaufen. Der Zug ist abgefahren :-)',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            await RoutingService().deleteRoute(user.uid);
                            await RoutingService().requestRoute(
                              uid: user.uid,
                              startAddress: routingService.startAddress,
                              endAddress: routingService.endAddress,
                              timestamp: DateTime.now(),
                            );

                            await Navigator.pushReplacementNamed(
                                context, UserRoutingScreen.routeName);
                          } catch (e) {
                            print(e);
                          }
                        },
                        child: Text('Route aktualisieren'),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextButton(
                        onPressed: () async {
                          try {
                            await Navigator.pushReplacementNamed(
                                context, UserMySublinScreen.routeName);
                          } catch (e) {
                            print(e);
                          }
                        },
                        child: Text('Andere Route suchen'),
                      )
                    ],
                  ),
                ));
              } else if (isRouteCompleted(routingService)) {
                // if (_timer != null) _timer.cancel();
                return Scaffold(
                    bottomNavigationBar: NavigationBarWidget(
                        isProvider: user.userType == UserType.provider,
                        setNavigationIndex: 1),
                    appBar: AppbarWidget(title: 'Fahrt abgeschlossen'),
                    body: Center(
                      child: Container(
                        padding: EdgeInsets.all(20),
                        width: MediaQuery.of(context).size.width,
                        height: 200,
                        child: Column(
                          children: <Widget>[
                            Text(
                              'Deine letzte Fahrt ist abgeschlossen',
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                try {
                                  addBoolToSF(
                                      Preferences.boolHasRatedTrip, true);
                                  await Navigator.pushReplacementNamed(
                                      context, UserMySublinScreen.routeName);
                                } catch (e) {
                                  print(e);
                                }
                              },
                              child: Text('Neue Fahrt starten'),
                            )
                          ],
                        ),
                      ),
                    ));
              } else {
                return UserShowRoutingScreen(
                    user: user,
                    routingService: routingService,
                    heightBookingBottomSheet: heightBookingBottomSheet);
              }
            } else if (screenArguments is Routing)
              return WaitingScreen(user: user, title: 'Wir suchen deine Fahrt');
            else
              return UserRoutingNoRouteScreen(
                user: user,
                icon: Icon(
                  Icons.help_outline,
                  size: 50,
                ),
                title: 'Keine Route',
                text: 'Bitte wähle eine Route aus',
                buttonText: 'Zu meinen Shuttles',
              );
          } else
            return WaitingScreen(user: user, title: 'Wir suchen deine Fahrt');
        });
  }
}
