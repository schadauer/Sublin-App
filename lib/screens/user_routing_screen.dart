import 'dart:async';

import 'package:Sublin/models/auth_class.dart';
import 'package:Sublin/models/direction_enum.dart';
import 'package:Sublin/models/preferences_enum.dart';
import 'package:Sublin/models/user_class.dart';
import 'package:Sublin/models/user_type_enum.dart';
import 'package:Sublin/screens/user_request_screen.dart';
import 'package:Sublin/services/auth_service.dart';
import 'package:Sublin/services/routing_service.dart';
import 'package:Sublin/services/shared_preferences_service.dart';
import 'package:Sublin/theme/theme.dart';
import 'package:Sublin/utils/convert_formatted_address_to_readable_address.dart';
import 'package:Sublin/utils/get_time_format.dart';
import 'package:Sublin/utils/is_route_completed.dart';
import 'package:Sublin/utils/is_sublin_available.dart';
import 'package:Sublin/widgets/appbar_widget.dart';
import 'package:Sublin/widgets/drawer_side_navigation_widget.dart';
import 'package:Sublin/widgets/navigation_bar_widget.dart';
import 'package:Sublin/widgets/user_step_notification_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Sublin/models/routing.dart';
import 'package:Sublin/widgets/step_icon_widget.dart';
import 'package:Sublin/widgets/step_widget.dart';

class UserRoutingScreen extends StatefulWidget {
  static const routeName = '/userRoutingScreen';
  @override
  _UserRoutingScreenState createState() => _UserRoutingScreenState();
}

class _UserRoutingScreenState extends State<UserRoutingScreen> {
  Timer _timer;
  // Completer<GoogleMapController> _controller = Completer();

  // static final CameraPosition _kGooglePlex = CameraPosition(
  //   target: LatLng(48.1652731, 16.3165917),
  //   zoom: 14,
  // );

  // static final CameraPosition _kLake = CameraPosition(
  //   // bearing: 192.8334901395799,
  //   target: LatLng(37.43296265331129, -122.08832357078792),
  //   tilt: 59.440717697143555,
  //   zoom: 19.151926040649414,
  // );

  @override
  Widget build(BuildContext context) {
    final Routing args = ModalRoute.of(context).settings.arguments;
    final Routing routingService = Provider.of<Routing>(context);
    final Auth auth = Provider.of<Auth>(context);
    final User user = Provider.of<User>(context);

    if (args != null) {
      if (args.startId != routingService.startId ||
          args.endId != routingService.endId) {
        // _timer = Timer.periodic(Duration(seconds: 10), (timer) {
        //   timer.cancel();
        //   Navigator.pushReplacementNamed(context, UserRequestScreen.routeName);
        // });
        return Scaffold(
            body: Center(
          child: Text('Deine Route wird neu berechnet'),
        ));
      }
    }

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

    if (!_isRouteAvailable()) {
      // if (_timer != null) _timer.cancel();
      return Scaffold(
          appBar: AppbarWidget(title: 'Meine Reiseroute'),
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
                    'Für diese Adresse gibt es leider noch kein Sublin-Service.',
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
      // If route is available - either start or end or both
      // if (_timer != null) _timer.cancel();
      return Scaffold(
          bottomNavigationBar: NavigationBarWidget(
              isProvider: user.userType == UserType.provider),
          // appBar: AppbarWidget(title: 'Meine Reiseroute'),
          // endDrawer: DrawerSideNavigationWidget(
          //   authService: AuthService(),
          // ),
          body: Container(
            color: Theme.of(context).primaryColor,
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
                  Container(
                      padding: EdgeInsets.only(
                        top: 140,
                        bottom: 210,
                      ),
                      height: MediaQuery.of(context).size.height,
                      child: ListView.builder(
                          itemCount: routingService.publicSteps.length,
                          itemBuilder: (context, index) {
                            if (routingService.publicSteps[index].distance ==
                                0) {
                              return StepWidget(
                                startAddress: routingService
                                    .publicSteps[index].startAddress,
                                endAddress: routingService
                                    .publicSteps[index].endAddress,
                                startTime:
                                    routingService.publicSteps[index].startTime,
                                endTime:
                                    routingService.publicSteps[index].endTime,
                                distance:
                                    routingService.publicSteps[index].distance,
                                duration:
                                    routingService.publicSteps[index].duration,
                              );
                            } else
                              return null;
                          })),
                  if (routingService.startAddressAvailable ||
                      routingService.isPubliclyAccessibleStartAddress)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: isSublinAvailable(
                                      Direction.start, routingService) &&
                                  routingService.booked == true
                              ? 200
                              : 140,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 5,
                                offset: Offset(
                                    4.0, 1.0), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              if (routingService.booked == true &&
                                  isSublinAvailable(
                                      Direction.start, routingService))
                                UserStepNotificationWidget(
                                    routingService: routingService,
                                    direction: Direction.start),
                              Container(
                                color: routingService.startAddressAvailable
                                    ? ThemeConstants.sublinMainBackgroundColor
                                    : Theme.of(context).primaryColor,
                                width: MediaQuery.of(context).size.width,
                                height: 140,
                                child: Stack(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Container(
                                          width: 60,
                                          height: 140,
                                        ),
                                        if (routingService
                                            .startAddressAvailable)
                                          Container(
                                            height: 140,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                60,
                                            padding: EdgeInsets.all(15),
                                            child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  AutoSizeText(
                                                    '${convertFormattedAddressToReadableAddress(routingService.sublinStartStep?.startAddress)}',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1,
                                                  ),
                                                  AutoSizeText(
                                                    'Abholung um ca. ${getTimeFormat(routingService.sublinStartStep?.startTime)}',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline1,
                                                  ),
                                                  AutoSizeText(
                                                    'Kostenloses Shuttleservice von deinem Standort zum Bahnhof durch ${routingService.sublinStartStep.provider?.providerName}',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .caption,
                                                  ),
                                                ]),
                                          ),
                                        if (!routingService
                                                .startAddressAvailable &&
                                            routingService
                                                .isPubliclyAccessibleStartAddress)
                                          Container(
                                            height: 120,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                60,
                                            padding: EdgeInsets.all(15),
                                            child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  AutoSizeText(
                                                    '${routingService.publicSteps[0]?.startAddress}',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1,
                                                  ),
                                                  AutoSizeText(
                                                    'Abfahrt um ${getTimeFormat(routingService.publicSteps[0]?.startTime)}',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline1,
                                                  ),
                                                ]),
                                          ),
                                      ],
                                    ),
                                    StepIconWidget(
                                      isStartAddress: true,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 210,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            if (routingService.endAddressAvailable)
                              Container(
                                color: routingService.endAddressAvailable
                                    ? Theme.of(context).secondaryHeaderColor
                                    : Theme.of(context).primaryColor,
                                width: MediaQuery.of(context).size.width,
                                height: 140,
                                child: Stack(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Container(
                                          width: 60,
                                          height: 140,
                                        ),
                                        Container(
                                          height: 140,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              60,
                                          padding: EdgeInsets.all(15),
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                AutoSizeText(
                                                  '${convertFormattedAddressToReadableAddress(routingService.sublinEndStep.endAddress)}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1,
                                                ),
                                                AutoSizeText(
                                                  'Ankunft um ca. ${getTimeFormat(routingService.sublinEndStep.endTime)}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline1,
                                                ),
                                                AutoSizeText(
                                                  'Kostenlose Abholung vom Bahnhof durch ${routingService.sublinEndStep.provider.providerName}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .caption,
                                                ),
                                              ]),
                                        ),
                                      ],
                                    ),
                                    StepIconWidget(
                                      isEndAddress: true,
                                    )
                                  ],
                                ),
                              ),
                            if (!routingService.endAddressAvailable &&
                                routingService.isPubliclyAccessibleEndAddress)
                              Container(
                                color: routingService.endAddressAvailable
                                    ? Theme.of(context).secondaryHeaderColor
                                    : Theme.of(context).primaryColor,
                                width: MediaQuery.of(context).size.width,
                                height: 140,
                                child: Stack(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Container(
                                          width: 60,
                                          height: 140,
                                        ),
                                        Container(
                                          height: 140,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              60,
                                          padding: EdgeInsets.all(15),
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                AutoSizeText(
                                                  '${routingService.publicSteps[routingService.publicSteps.length - 1].endAddress}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1,
                                                ),
                                                AutoSizeText(
                                                  'Planmäßige Ankunft um ${getTimeFormat(routingService.publicSteps[routingService.publicSteps.length - 1].endTime)}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline1,
                                                ),
                                              ]),
                                        ),
                                      ],
                                    ),
                                    StepIconWidget(
                                      isEndAddress: true,
                                    )
                                  ],
                                ),
                              ),
                            if (routingService.booked == true &&
                                isSublinAvailable(
                                    Direction.end, routingService))
                              UserStepNotificationWidget(
                                  routingService: routingService,
                                  direction: Direction.end),
                            if (routingService.booked == false)
                              Container(
                                height: 70,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    FlatButton(
                                        onPressed: () async {
                                          // await RoutingService().removeProviderFromRoute(user.uid);
                                          Navigator.pushReplacementNamed(
                                              context,
                                              UserRequestScreen.routeName);
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
