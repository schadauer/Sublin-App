import 'dart:async';
import 'package:Sublin/models/auth.dart';
import 'package:Sublin/services/auth_service.dart';
import 'package:Sublin/services/routing_service.dart';
import 'package:Sublin/utils/get_time_format.dart';
import 'package:Sublin/widgets/appbar_widget.dart';
import 'package:Sublin/widgets/drawer_side_navigation_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:Sublin/models/routing.dart';
import 'package:Sublin/widgets/step_icon_widget.dart';
import 'package:Sublin/widgets/step_widget.dart';

class RoutingScreen extends StatefulWidget {
  static const routeName = '/routingScreen';
  @override
  _RoutingScreenState createState() => _RoutingScreenState();
}

class _RoutingScreenState extends State<RoutingScreen> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(48.1652731, 16.3165917),
    zoom: 14,
  );

  static final CameraPosition _kLake = CameraPosition(
      // bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    final Routing args = ModalRoute.of(context).settings.arguments;
    final Routing routingService = Provider.of<Routing>(context);
    final Auth auth = Provider.of<Auth>(context);

    if (args != null) {
      if (args.startId != routingService.startId ||
          args.endId != routingService.endId) {
        return Scaffold(
            body: Center(
          child: Text('Deine Route wird neu berechnet'),
        ));
      }
    }
    if (routingService.endAddressAvailable == false) {
      return Scaffold(
          appBar: AppbarWidget(title: 'Meine Reise'),
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
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Andere Route suchen'),
                  )
                ],
              ),
            ),
          ));
    } else {
      return Scaffold(
          appBar: AppbarWidget(title: 'Meine Reise'),
          endDrawer: DrawerSideNavigationWidget(
            authService: AuthService(),
          ),
          body: SafeArea(
            child: Stack(
              children: <Widget>[
                GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: _kGooglePlex,
                ),
                Container(
                    padding: EdgeInsets.only(
                      top: routingService.sublinStartStep != null ? 160 : 0,
                      bottom: routingService.sublinEndStep != null ? 160 : 0,
                    ),
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                        itemCount: routingService.publicSteps.length,
                        itemBuilder: (context, index) {
                          if (routingService.publicSteps[index].distance == 0) {
                            return StepWidget(
                              startAddress: routingService
                                  .publicSteps[index].startAddress,
                              endAddress:
                                  routingService.publicSteps[index].endAddress,
                              startTime:
                                  routingService.publicSteps[index].startTime,
                              endTime:
                                  routingService.publicSteps[index].endTime,
                              // provider: routingService.publicSteps[index].provider,
                              distance:
                                  routingService.publicSteps[index].distance,
                              duration:
                                  routingService.publicSteps[index].duration,
                            );
                          } else
                            return null;
                        })),
                if (routingService.startAddressAvailable)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 160,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 160,
                              child: Stack(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.all(0),
                                        width: 60,
                                        height: 100,
                                        color: Colors.white54,
                                      ),
                                      Expanded(
                                        child: Container(
                                          height: 100,
                                          padding: EdgeInsets.all(15),
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  'Abfahrt ca. ${getTimeFormat(routingService.sublinStartStep.endTime)}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline3,
                                                ),
                                                Text(
                                                  'Abholung durch ${routingService.sublinStartStep.provider.providerName}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1,
                                                ),
                                              ]),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      FlatButton(
                                          onPressed: () async {
                                            // await RoutingService().removeProviderFromRoute(user.uid);
                                            Navigator.pop(context);
                                          },
                                          child: Text('Ädresse ändern')),
                                      RaisedButton(
                                          onPressed: routingService.booked
                                              ? null
                                              : () {
                                                  RoutingService()
                                                      .bookRoute(uid: auth.uid);
                                                },
                                          child: Text('Jetzt buchen'))
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
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 100,
                                child: Stack(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.all(0),
                                          width: 60,
                                          height: 100,
                                          color: Colors.white54,
                                        ),
                                        Expanded(
                                          child: Container(
                                            height: 100,
                                            padding: EdgeInsets.all(15),
                                            child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    'Ankunft ca. ${getTimeFormat(routingService.sublinEndStep.endTime)}',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline3,
                                                  ),
                                                  Text(
                                                    'Abholung durch ${routingService.sublinEndStep.provider.providerName}',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1,
                                                  ),
                                                ]),
                                          ),
                                        ),
                                      ],
                                    ),
                                    StepIconWidget(
                                      isEndAddress: true,
                                    )
                                  ],
                                ),
                              ),
                              if (routingService.booked == false)
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    FlatButton(
                                        onPressed: () async {
                                          // await RoutingService().removeProviderFromRoute(user.uid);
                                          Navigator.pop(context);
                                        },
                                        child: Text('Ädresse ändern')),
                                    RaisedButton(
                                        onPressed: routingService.booked
                                            ? null
                                            : () {
                                                RoutingService()
                                                    .bookRoute(uid: auth.uid);
                                              },
                                        child: Text('Jetzt buchen'))
                                  ],
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ));
    }
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
