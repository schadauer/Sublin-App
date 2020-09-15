import 'dart:async';

import 'package:Sublin/models/auth_class.dart';
import 'package:Sublin/models/direction_enum.dart';
import 'package:Sublin/models/preferences_enum.dart';
import 'package:Sublin/models/user_class.dart';
import 'package:Sublin/models/user_type_enum.dart';
import 'package:Sublin/screens/user_my_sublin_screen.dart';
import 'package:Sublin/screens/user_request_screen.dart';
import 'package:Sublin/services/auth_service.dart';
import 'package:Sublin/services/routing_service.dart';
import 'package:Sublin/services/shared_preferences_service.dart';
import 'package:Sublin/theme/theme.dart';
import 'package:Sublin/utils/is_route_completed.dart';
import 'package:Sublin/widgets/appbar_widget.dart';
import 'package:Sublin/widgets/drawer_side_navigation_widget.dart';
import 'package:Sublin/widgets/navigation_bar_widget.dart';
import 'package:Sublin/widgets/user_routing_start_end_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Sublin/models/routing.dart';
import 'package:Sublin/widgets/step_widget.dart';

enum StepType {
  start,
  public,
  end,
}

class UserRoutingScreen extends StatefulWidget {
  static const routeName = '/userRoutingScreen';
  @override
  _UserRoutingScreenState createState() => _UserRoutingScreenState();
}

class _UserRoutingScreenState extends State<UserRoutingScreen> {
  Timer _timer;
  int currentTime = DateTime.now().millisecondsSinceEpoch;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Routing args = ModalRoute.of(context).settings.arguments;
    final Routing routingService = Provider.of<Routing>(context);
    final Auth auth = Provider.of<Auth>(context);
    final User user = Provider.of<User>(context);
    double heightBookingBottomSheet = 70.0;

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
      return startAddressIsAvailable == true && endAddressIsAvailable == true;
    }

    double _getRoutingStepHight(StepType steptype, Routing routingService) {
      // We need to calculate the screen height minus the bottom navigation and the appbar
      double safePaddingTop = MediaQuery.of(context).padding.top;
      double safePaddingBottom = MediaQuery.of(context).padding.bottom;
      print(safePaddingBottom);
      double screenSize = MediaQuery.of(context).size.height < 700.0
          ? 700
          : MediaQuery.of(context).size.height;
      double availableHight = screenSize -
          kBottomNavigationBarHeight -
          160 -
          safePaddingTop -
          safePaddingBottom;
      double heightOfStepCard = 80.0;
      double numberOfStartOrEndSteps = 0;
      if (routingService.isPubliclyAccessibleEndAddress == true)
        numberOfStartOrEndSteps += 1;
      if (routingService.isPubliclyAccessibleStartAddress == true)
        numberOfStartOrEndSteps += 1;
      double numberOfPublicSteps =
          routingService.publicSteps.length.toDouble() -
              numberOfStartOrEndSteps;
      if (numberOfPublicSteps > 2) numberOfPublicSteps = 2.5;
      switch (steptype) {
        case StepType.start:
        case StepType.end:
          return (availableHight - (heightOfStepCard * numberOfPublicSteps)) /
              2;
          break;
        case StepType.public:
          return heightOfStepCard * numberOfPublicSteps;
          break;
      }
    }

    bool _isRouteExpired() {
      // int startTime = routingService.isPubliclyAccessibleStartAddress
      //     ? routingService.publicSteps[1].startTime
      //     : routingService.sublinStartStep.startTime;
      // if (startTime * 1000 > DateTime.now().millisecondsSinceEpoch)
      //   return false;
      // else
      //   return true;
      return false;
    }

    if (!_isRouteAvailable()) {
      return Scaffold(
          appBar: AppbarWidget(title: 'Meine aktuelle Fahrt'),
          endDrawer: DrawerSideNavigationWidget(
            authService: AuthService(),
          ),
          body: Center(
            child: Padding(
              padding: ThemeConstants.largePadding,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.sentiment_dissatisfied,
                    size: 50,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Für diese Adresse gibt es leider noch kein Sublin-Service.',
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  RaisedButton(
                    onPressed: () async {
                      try {
                        await Navigator.pushReplacementNamed(
                            context, UserRequestScreen.routeName);
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: Text('Andere Route suchen'),
                  )
                ],
              ),
            ),
          ));
    } else if (_isRouteExpired()) {
      return Scaffold(
          appBar: AppbarWidget(title: 'Abgelaufene Fahrt'),
          endDrawer: DrawerSideNavigationWidget(
            authService: AuthService(),
          ),
          body: Center(
            child: Container(
              padding: EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width,
              height: 200,
              child: Column(
                children: <Widget>[
                  Text(
                    'Deine Route ist nicht mehr aktuell',
                  ),
                  RaisedButton(
                    onPressed: () async {
                      try {
                        await Navigator.pushReplacementNamed(
                            context, UserRequestScreen.routeName);
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: Text('Andere Route suchen'),
                  )
                ],
              ),
            ),
          ));
    } else if (isRouteCompleted(routingService)) {
      // if (_timer != null) _timer.cancel();
      return Scaffold(
          bottomNavigationBar: NavigationBarWidget(
              isProvider: user.userType == UserType.provider),
          appBar: AppbarWidget(title: 'Fahrt abgeschlossen'),
          endDrawer: DrawerSideNavigationWidget(
            authService: AuthService(),
          ),
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
                  RaisedButton(
                    onPressed: () async {
                      try {
                        addBoolToSF(Preferences.boolHasRatedTrip, true);
                        await Navigator.pushReplacementNamed(
                            context, UserRequestScreen.routeName);
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
      return Scaffold(
          bottomNavigationBar: NavigationBarWidget(
              isProvider: user.userType == UserType.provider),
          appBar: AppbarWidget(title: 'Meine aktuelle Fahrt'),
          endDrawer: DrawerSideNavigationWidget(
            authService: AuthService(),
          ),
          body: Container(
            child: SafeArea(
              child: Stack(
                children: <Widget>[
                  Container(
                      width: 80,
                      height: double.infinity,
                      child: Stack(children: <Widget>[
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                height: double.infinity,
                                width: 2,
                                color: Colors.black,
                              ),
                            ]),
                      ])),
                  // -------------------------These are the public steps -----------------------------
                  Container(
                      padding: EdgeInsets.only(
                        top: _getRoutingStepHight(
                            StepType.start, routingService),
                      ),
                      height: MediaQuery.of(context).size.height,
                      child: ListView.builder(
                          itemCount: routingService.publicSteps.length,
                          itemBuilder: (context, index) {
                            if (routingService.publicSteps[index].travelMode ==
                                'TRANSIT') {
                              return StepWidget(
                                startAddress: routingService
                                    .publicSteps[index].startAddress,
                                startTime:
                                    routingService.publicSteps[index].startTime,
                                endAddress: routingService
                                    .publicSteps[index].endAddress,
                                endTime:
                                    routingService.publicSteps[index].endTime,
                                distance:
                                    routingService.publicSteps[index].distance,
                                duration:
                                    routingService.publicSteps[index].duration,
                                providerName: routingService
                                    .publicSteps[index].providerName,
                                lineName:
                                    routingService.publicSteps[index].lineName,
                              );
                            } else
                              return Container();
                          })),
                  // -------------------------These is the start step steps -----------------------------
                  // if (routingService.startAddressAvailable ||
                  //     routingService.isPubliclyAccessibleStartAddress)
                  UserRoutingStartEndWidget(
                    direction: Direction.start,
                    routingService: routingService,
                    stepHeight:
                        _getRoutingStepHight(StepType.start, routingService),
                  ),
                  // ------------------------------These is the end steps -----------------------------
                  UserRoutingStartEndWidget(
                    direction: Direction.end,
                    routingService: routingService,
                    stepHeight:
                        _getRoutingStepHight(StepType.start, routingService),
                    heightBookingSheet: heightBookingBottomSheet,
                  ),
                  // ------------------------ This is the bottom sheet for ordering -------------------------

                  if (routingService.booked == false)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: heightBookingBottomSheet,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              FlatButton(
                                  onPressed: () async {
                                    // await RoutingService().removeProviderFromRoute(user.uid);
                                    Navigator.pushNamed(
                                        context, UserMySublinScreen.routeName);
                                  },
                                  child: Text('Route ändern')),
                              RaisedButton(
                                  onPressed: routingService.booked
                                      ? null
                                      : () {
                                          RoutingService()
                                              .bookRoute(uid: auth.uid);
                                        },
                                  child: Text('Service bestellen'))
                            ],
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ));
    }
  }
}
