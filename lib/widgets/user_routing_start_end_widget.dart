import 'package:Sublin/models/direction_enum.dart';
import 'package:Sublin/models/routing.dart';
import 'package:Sublin/models/step.dart' as sublin;
import 'package:Sublin/theme/theme.dart';
import 'package:Sublin/utils/is_sublin_available.dart';
import 'package:Sublin/utils/convert_formatted_address_to_readable_address.dart';
import 'package:Sublin/utils/get_time_format.dart';
import 'package:Sublin/widgets/step_icon_widget.dart';
import 'package:Sublin/widgets/user_step_notification_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class UserRoutingStartEndWidget extends StatelessWidget {
  const UserRoutingStartEndWidget({
    Key key,
    @required this.routingService,
    @required this.stepHeight,
    @required this.direction,
  }) : super(key: key);

  final Routing routingService;
  final double stepHeight;

  final Direction direction;

  @override
  Widget build(BuildContext context) {
    final sublin.Step step = direction == Direction.start
        ? routingService.sublinStartStep
        : routingService.sublinEndStep;
    bool _isSublinService = false;
    if (direction == Direction.start && routingService.startAddressAvailable ||
        direction == Direction.end && routingService.endAddressAvailable)
      _isSublinService = true;
    return Column(
      mainAxisAlignment: direction == Direction.start
          ? MainAxisAlignment.start
          : MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          height: stepHeight,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 5,
                offset: Offset(4.0, 1.0), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              if (routingService.booked == true &&
                  isSublinAvailable(Direction.start, routingService))
                UserStepNotificationWidget(
                    routingService: routingService, direction: Direction.start),
              Container(
                color: _isSublinService
                    ? ThemeConstants.sublinMainBackgroundColor
                    : Theme.of(context).primaryColor,
                width: MediaQuery.of(context).size.width,
                height: stepHeight,
                child: Stack(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 60,
                          height: stepHeight,
                        ),
                        if (routingService.startAddressAvailable)
                          Container(
                            height: 140,
                            width: MediaQuery.of(context).size.width - 60,
                            padding: EdgeInsets.all(15),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  AutoSizeText(
                                    '${convertFormattedAddressToReadableAddress(routingService.sublinStartStep?.startAddress)}',
                                    style:
                                        Theme.of(context).textTheme.headline1,
                                    maxLines: 2,
                                  ),
                                  AutoSizeText(
                                    'Abholung um ca. ${getTimeFormat(routingService.sublinStartStep?.startTime)}',
                                    style: ThemeConstants.veryLargeHeader,
                                  ),
                                  AutoSizeText(
                                    'Kostenloses Shuttleservice von deinem Standort zum Bahnhof durch ${routingService.sublinStartStep.provider?.providerName}',
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                ]),
                          ),
                        if (direction == Direction.start &&
                                !routingService.startAddressAvailable &&
                                routingService
                                    .isPubliclyAccessibleStartAddress ||
                            direction == Direction.end &&
                                routingService.endAddressAvailable &&
                                !routingService.isPubliclyAccessibleEndAddress)
                          Container(
                            height: stepHeight,
                            width: MediaQuery.of(context).size.width - 60,
                            padding: EdgeInsets.all(15),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 4,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            if (direction == Direction.start)
                                              AutoSizeText(
                                                '${routingService.publicSteps[0]?.startAddress}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline1,
                                              ),
                                            if (direction == Direction.end)
                                              Column(
                                                children: [
                                                  AutoSizeText(
                                                    '${routingService.publicSteps[routingService.publicSteps.length - 1]?.endAddress}',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline2,
                                                  ),
                                                ],
                                              ),
                                            FlatButton(
                                              child: Text('Addresse ändern'),
                                              onPressed: null,
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          children: [
                                            if (direction == Direction.start)
                                              AutoSizeText(
                                                '${getTimeFormat(routingService.publicSteps[0]?.startTime)}',
                                                style: ThemeConstants
                                                    .veryLargeHeader,
                                                maxLines: 2,
                                                textAlign: TextAlign.right,
                                              ),
                                            if (direction == Direction.end)
                                              AutoSizeText(
                                                '${getTimeFormat(routingService.publicSteps[routingService.publicSteps.length - 1]?.endTime)}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline1,
                                                maxLines: 2,
                                                textAlign: TextAlign.right,
                                              ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ]),
                          ),
                      ],
                    ),
                    StepIconWidget(
                      isStartAddress: direction == Direction.start,
                      isEndAddress: direction == Direction.end,
                      icon: Icons.directions_walk,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
