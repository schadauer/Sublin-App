import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:Sublin/models/direction_enum.dart';
import 'package:Sublin/models/routing_class.dart';
import 'package:Sublin/models/step_class.dart' as sublin;
import 'package:Sublin/models/travel_mode_class.dart';
import 'package:Sublin/theme/theme.dart';
import 'package:Sublin/utils/get_readable_address_from_formatted_address.dart';
import 'package:Sublin/utils/get_time_format.dart';
import 'package:Sublin/utils/launch_caller.dart';
import 'package:Sublin/widgets/step_icon_widget.dart';

class UserRoutingStartEndWidget extends StatelessWidget {
  const UserRoutingStartEndWidget({
    Key key,
    @required this.routingService,
    @required this.stepHeight,
    @required this.direction,
    this.heightBookingSheet = 0.0,
  }) : super(key: key);

  final Routing routingService;
  final double stepHeight;
  final Direction direction;
  final double heightBookingSheet;

  @override
  Widget build(BuildContext context) {
    final sublin.Step step = direction == Direction.start
        ? routingService.sublinStartStep
        : routingService.sublinEndStep;
    // Is it a Sublin service or public service?
    bool _isSublinService = false;
    // BookingStatus bookingStatusStart;
    // BookingStatus bookingStatusEnd;
    bool _isStartBooked = false;
    bool _isEndBooked = false;
    bool _isStartConfirmed = false;
    bool _isEndConfirmed = false;

    if (direction == Direction.start && routingService.startAddressAvailable ||
        direction == Direction.end && routingService.endAddressAvailable)
      _isSublinService = true;

    if (routingService.booked != null) {
      _isStartBooked = routingService.booked == true &&
          direction == Direction.start &&
          routingService.startAddressAvailable;
      _isEndBooked = routingService.booked == true &&
          direction == Direction.end &&
          routingService.endAddressAvailable;
    }
    if (routingService.startAddressAvailable)
      _isStartConfirmed = routingService.sublinStartStep.confirmed;
    if (routingService.endAddressAvailable)
      _isEndConfirmed = routingService.sublinEndStep.confirmed;

    return Expanded(
      flex: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Container(
              color: ThemeConstants.backgroundColor,
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
                      Container(
                        height: stepHeight,
                        width: MediaQuery.of(context).size.width - 60,
                        padding: EdgeInsets.only(
                          top: 20,
                          bottom: 10,
                          left: 10,
                          right: 15,
                        ),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 4,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            //  ------------------------------------------- START ADDRESS ----------------------------------------------

                                            if (direction == Direction.start &&
                                                routingService
                                                    .startAddressAvailable)
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      child: AutoSizeText(
                                                        '${getReadableAddressFromFormattedAddress(step.startAddress)}',
                                                        maxLines: 2,
                                                        style: ThemeConstants
                                                            .veryLargeHeader,
                                                      ),
                                                    ),
                                                    if (!_isStartBooked)
                                                      Expanded(
                                                        child: AutoSizeText(
                                                          'Transfer zum Bahnhof durch ${step.provider.providerName}',
                                                        ),
                                                      ),
                                                    if (_isStartBooked)
                                                      Expanded(
                                                        child: Row(
                                                          children: [
                                                            SizedBox(
                                                                width: 50,
                                                                child: Icon(Icons
                                                                    .phone)),
                                                            Expanded(
                                                              child:
                                                                  AutoSizeText(
                                                                (routingService
                                                                            .sublinStartStep
                                                                            .confirmed ==
                                                                        false)
                                                                    ? 'Wir benachrichten dich, sobald ${step.provider?.providerName} deine Abholung bestätigt hat.'
                                                                    : routingService.sublinStartStep.completed ==
                                                                            false
                                                                        ? '${step.provider?.providerName} hat deine Abholung bestätigt.'
                                                                        : '${step.provider?.providerName} hat deine Abholung ab abgeschlossen.',
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    Expanded(
                                                      child: Row(
                                                        children: [
                                                          Icon(Icons
                                                              .keyboard_tab),
                                                          SizedBox(width: 5),
                                                          Expanded(
                                                            child: AutoSizeText(
                                                              '${routingService.publicSteps[0].startAddress}',
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .caption,
                                                              maxLines: 2,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                            if (direction == Direction.start &&
                                                routingService
                                                    .isPubliclyAccessibleStartAddress &&
                                                routingService.publicSteps[0]
                                                        .travelMode ==
                                                    TravelMode.walking)
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      child: AutoSizeText(
                                                        '${routingService.publicSteps[0].startAddress}',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline2,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: AutoSizeText(
                                                        'Fußweg',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .caption,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          SizedBox(
                                                            width: 30,
                                                            child: Icon(Icons
                                                                .keyboard_tab),
                                                          ),
                                                          SizedBox(width: 5),
                                                          Expanded(
                                                            child: Align(
                                                              alignment: Alignment
                                                                  .bottomLeft,
                                                              child:
                                                                  AutoSizeText(
                                                                '${routingService.publicSteps[0].endAddress}',
                                                                maxLines: 2,
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .caption,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            if (direction == Direction.start &&
                                                routingService
                                                    .isPubliclyAccessibleStartAddress &&
                                                routingService.publicSteps[0]
                                                        .travelMode ==
                                                    TravelMode.transit)
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      child: AutoSizeText(
                                                        '${routingService.publicSteps[0].startAddress}',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline2,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Expanded(
                                                      child: Align(
                                                        alignment:
                                                            Alignment.topLeft,
                                                        child: AutoSizeText(
                                                          'Derzeit noch kein Sublin-Service verfügbar.',
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .caption,
                                                          maxLines: 2,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            //  ------------------------------------------- END ADDRESS ----------------------------------------------
                                            if (direction == Direction.end &&
                                                routingService
                                                    .endAddressAvailable)
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      child: AutoSizeText(
                                                        '${routingService.publicSteps[routingService.publicSteps.length - 1]?.endAddress}',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline2,
                                                      ),
                                                    ),
                                                    if (direction ==
                                                            Direction.end &&
                                                        !_isEndBooked)
                                                      Expanded(
                                                        child: AutoSizeText(
                                                          'Abholung durch ${step.provider.providerName}',
                                                        ),
                                                      ),
                                                    if (_isEndBooked)
                                                      Expanded(
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            if (step.provider
                                                                    .phone !=
                                                                null)
                                                              launchCaller(step
                                                                  .provider
                                                                  .phone);
                                                          },
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                child:
                                                                    AutoSizeText(
                                                                  (routingService
                                                                              .sublinEndStep
                                                                              .confirmed ==
                                                                          false)
                                                                      ? 'Wir benachrichten dich, sobald ${step.provider?.providerName} deine Abholung bestätigt hat.'
                                                                      : routingService.sublinEndStep.completed ==
                                                                              false
                                                                          ? '${step.provider?.providerName} hat deine Abholung bestätigt.'
                                                                          : '${step.provider?.providerName} hat deine Abholung ab abgeschlossen.',
                                                                ),
                                                              ),
                                                              if (step.provider
                                                                      .phone !=
                                                                  null)
                                                                SizedBox(
                                                                    width: 50,
                                                                    child: Icon(
                                                                        Icons
                                                                            .phone)),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    Expanded(
                                                      child: AutoSizeText(
                                                        '${getReadableAddressFromFormattedAddress(step.endAddress)}',
                                                        maxLines: 2,
                                                        minFontSize: 15,
                                                        style: ThemeConstants
                                                            .veryLargeHeader,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            if (direction == Direction.end &&
                                                routingService
                                                    .isPubliclyAccessibleEndAddress &&
                                                routingService
                                                        .publicSteps[
                                                            routingService
                                                                    .publicSteps
                                                                    .length -
                                                                1]
                                                        .travelMode ==
                                                    TravelMode.walking)
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          AutoSizeText(
                                                            '${routingService.publicSteps[routingService.publicSteps.length - 1].startAddress}',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .headline2,
                                                          ),
                                                          if (routingService
                                                                  .publicSteps[
                                                                      routingService
                                                                              .publicSteps
                                                                              .length -
                                                                          1]
                                                                  .travelMode ==
                                                              TravelMode
                                                                  .transit)
                                                            AutoSizeText(
                                                              'Fußweg',
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyText1,
                                                            ),
                                                        ],
                                                      ),
                                                    ),
                                                    AutoSizeText(
                                                      '${routingService.publicSteps[routingService.publicSteps.length - 1].endAddress}',
                                                      minFontSize: 20,
                                                      style: ThemeConstants
                                                          .veryLargeHeader,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            if (direction == Direction.end &&
                                                routingService
                                                    .isPubliclyAccessibleEndAddress &&
                                                routingService
                                                        .publicSteps[
                                                            routingService
                                                                    .publicSteps
                                                                    .length -
                                                                1]
                                                        .travelMode ==
                                                    TravelMode.transit)
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    Expanded(
                                                      child: AutoSizeText(
                                                        '${routingService.publicSteps[routingService.publicSteps.length - 1].endAddress}',
                                                        minFontSize: 20,
                                                        style: ThemeConstants
                                                            .veryLargeHeader,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: AutoSizeText(
                                                        'Derzeit noch kein Sublin-Service verfügbar.',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyText1,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            //  ------------------------------------------- START TIME ----------------------------------------------
                                            if (direction == Direction.start &&
                                                routingService
                                                    .isPubliclyAccessibleStartAddress)
                                              Expanded(
                                                child: AutoSizeText(
                                                  '${getTimeFormat(routingService.publicSteps[0]?.startTime)}',
                                                  style: ThemeConstants
                                                      .veryLargeHeader,
                                                  maxLines: 1,
                                                  textAlign: TextAlign.right,
                                                ),
                                              ),
                                            if (direction == Direction.start &&
                                                routingService
                                                    .startAddressAvailable)
                                              Expanded(
                                                child: AutoSizeText(
                                                  '${getTimeFormat(routingService.sublinStartStep.startTime)}',
                                                  style: ThemeConstants
                                                      .veryLargeHeader,
                                                  maxLines: 1,
                                                  textAlign: TextAlign.right,
                                                ),
                                              ),
                                            if (direction == Direction.start &&
                                                routingService
                                                    .startAddressAvailable)
                                              Expanded(
                                                child: Align(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  child: AutoSizeText(
                                                    '${getTimeFormat(routingService.sublinStartStep.endTime)}',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .caption,
                                                    maxLines: 1,
                                                    textAlign: TextAlign.right,
                                                  ),
                                                ),
                                              ),
                                            if (direction == Direction.end &&
                                                routingService
                                                    .endAddressAvailable)
                                              Expanded(
                                                child: AutoSizeText(
                                                  '${getTimeFormat(routingService.sublinEndStep.startTime)}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .caption,
                                                  maxLines: 2,
                                                  textAlign: TextAlign.right,
                                                ),
                                              ),
                                            //  ------------------------------------------- END TIME ----------------------------------------------
                                            if (direction == Direction.end &&
                                                routingService
                                                    .endAddressAvailable)
                                              Expanded(
                                                child: Align(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  child: AutoSizeText(
                                                    '${getTimeFormat(routingService.sublinEndStep.endTime)}',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline1,
                                                    maxLines: 2,
                                                  ),
                                                ),
                                              ),
                                            if (direction == Direction.end &&
                                                routingService
                                                    .isPubliclyAccessibleEndAddress &&
                                                routingService
                                                        .publicSteps[
                                                            routingService
                                                                    .publicSteps
                                                                    .length -
                                                                1]
                                                        .travelMode ==
                                                    'WALKING')
                                              Expanded(
                                                child: AutoSizeText(
                                                  '${getTimeFormat(routingService.publicSteps[routingService.publicSteps.length - 1]?.startTime)}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .caption,
                                                  maxLines: 2,
                                                  textAlign: TextAlign.right,
                                                ),
                                              ),
                                            if (direction == Direction.end &&
                                                routingService
                                                    .isPubliclyAccessibleEndAddress)
                                              Expanded(
                                                child: AutoSizeText(
                                                  '${getTimeFormat(routingService.publicSteps[routingService.publicSteps.length - 1]?.endTime)}',
                                                  style: ThemeConstants
                                                      .veryLargeHeader,
                                                  maxLines: 1,
                                                  textAlign: TextAlign.right,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ]),
                      ),
                    ],
                  ),
                  StepIconWidget(
                    isSublinService: _isSublinService,
                    isStartAddress: direction == Direction.start,
                    isEndAddress: direction == Direction.end,
                    isBooked: direction == Direction.start && _isStartBooked ||
                        direction == Direction.end && _isEndBooked,
                    isConfirmed:
                        direction == Direction.start && _isStartConfirmed ||
                            direction == Direction.end && _isEndConfirmed,
                    icon: _isSublinService
                        ? Icons.directions_car
                        : Icons.directions_walk,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
