import 'package:Sublin/models/direction_enum.dart';
import 'package:Sublin/models/routing_class.dart';
import 'package:Sublin/models/routing_step_type_enum.dart';
import 'package:Sublin/models/user_class.dart';
import 'package:Sublin/models/user_type_enum.dart';
import 'package:Sublin/screens/user_my_sublin_screen.dart';
import 'package:Sublin/services/routing_service.dart';
import 'package:Sublin/widgets/appbar_widget.dart';
import 'package:Sublin/widgets/navigation_bar_widget.dart';
import 'package:Sublin/widgets/step_widget.dart';
import 'package:Sublin/widgets/user_routing_start_end_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UserShowRoutingScreen extends StatelessWidget {
  const UserShowRoutingScreen({
    Key key,
    @required this.user,
    @required this.routingService,
    @required this.heightBookingBottomSheet,
  }) : super(key: key);

  final User user;
  final Routing routingService;
  final double heightBookingBottomSheet;

  @override
  Widget build(BuildContext context) {
    double _getRoutingStepHeight(StepType steptype, Routing routingService) {
      // We need to calculate the screen height minus the bottom navigation and the appbar
      double safePaddingTop = MediaQuery.of(context).padding.top;
      double safePaddingBottom = MediaQuery.of(context).padding.bottom;
      double screenSize = MediaQuery.of(context).size.height < 700.0
          ? 700
          : MediaQuery.of(context).size.height;
      double availableHight = screenSize -
          kBottomNavigationBarHeight -
          140 -
          safePaddingTop -
          safePaddingBottom;
      double heightOfStepCard = 100.0;
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
      return 0.0;
    }

    return Scaffold(
        bottomNavigationBar: NavigationBarWidget(
          isProvider: user.userType == UserType.provider,
          setNavigationIndex: 1,
        ),
        appBar: AppbarWidget(title: 'Meine Fahrt'),
        body: Container(
          child: SafeArea(
            child: Stack(
              children: <Widget>[
                Container(
                    width: 70,
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
                      top:
                          _getRoutingStepHeight(StepType.start, routingService),
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
                              endAddress:
                                  routingService.publicSteps[index].endAddress,
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
                            return Container(width: 0.0, height: 0.0);
                        })),
                // -------------------------These is the start step steps -----------------------------
                // if (routingService.startAddressAvailable ||
                //     routingService.isPubliclyAccessibleStartAddress)
                UserRoutingStartEndWidget(
                  direction: Direction.start,
                  routingService: routingService,
                  stepHeight:
                      _getRoutingStepHeight(StepType.start, routingService),
                ),
                // ------------------------------These is the end steps -----------------------------
                UserRoutingStartEndWidget(
                  direction: Direction.end,
                  routingService: routingService,
                  stepHeight:
                      _getRoutingStepHeight(StepType.start, routingService),
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
                                child: Text('Andere Fahrt')),
                            RaisedButton(
                                onPressed: routingService.booked
                                    ? null
                                    : () {
                                        HapticFeedback.mediumImpact();
                                        RoutingService()
                                            .bookRoute(uid: user.uid);
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
