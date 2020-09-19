import 'package:Sublin/models/direction_enum.dart';
import 'package:Sublin/models/routing.dart';
import 'package:Sublin/models/step.dart' as sublin;
import 'package:Sublin/theme/theme.dart';
import 'package:Sublin/utils/get_readable_address_from_formatted_address.dart';
import 'package:Sublin/utils/get_time_format.dart';
import 'package:Sublin/widgets/step_icon_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

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
    if (direction == Direction.start && routingService.startAddressAvailable ||
        direction == Direction.end && routingService.endAddressAvailable)
      _isSublinService = true;
    bool isStartUserNotificationWidgetOn = routingService.booked == true &&
        direction == Direction.start &&
        routingService.startAddressAvailable;
    bool isEndUserNotificationWidgetOn = routingService.booked == true &&
        direction == Direction.end &&
        routingService.endAddressAvailable;

    return Column(
      mainAxisAlignment: direction == Direction.start
          ? MainAxisAlignment.start
          : MainAxisAlignment.end,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          height: stepHeight + heightBookingSheet,
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
              Container(
                color: _isSublinService
                    ? Theme.of(context).primaryColor
                    : Colors.white,
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
                            left: 20,
                            right: 15,
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
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
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    AutoSizeText(
                                                      '${getReadableAddressFromFormattedAddress(step.startAddress)}',
                                                      maxLines: 2,
                                                      style: ThemeConstants
                                                          .veryLargeHeader,
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    if (!isStartUserNotificationWidgetOn)
                                                      Expanded(
                                                        child: AutoSizeText(
                                                          'Transfer zum Bahnhof durch ${step.provider.providerName}',
                                                        ),
                                                      ),
                                                    if (isStartUserNotificationWidgetOn)
                                                      Expanded(
                                                        child: AutoSizeText(
                                                          (routingService
                                                                      .sublinStartStep
                                                                      .confirmed ==
                                                                  false)
                                                              ? 'Wir benachrichten dich, sobald ${step.provider?.providerName} deine Abholung bestätigt hat.'
                                                              : routingService
                                                                          .sublinStartStep
                                                                          .completed ==
                                                                      false
                                                                  ? '${step.provider?.providerName} hat deine Abholung bestätigt.'
                                                                  : '${step.provider?.providerName} hat deine Abholung ab abgeschlossen.',
                                                        ),
                                                      ),
                                                    Expanded(
                                                      child: Row(
                                                        children: [
                                                          Icon(Icons
                                                              .keyboard_tab),
                                                          SizedBox(width: 5),
                                                          AutoSizeText(
                                                            '${routingService.publicSteps[0].startAddress}',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .caption,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                            if (direction == Direction.start &&
                                                routingService
                                                    .isPubliclyAccessibleStartAddress)
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    AutoSizeText(
                                                      '${routingService.publicSteps[0].startAddress}',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline1,
                                                    ),
                                                    AutoSizeText(
                                                      'Fußweg',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText1,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Icon(
                                                            Icons.keyboard_tab),
                                                        SizedBox(width: 5),
                                                        Expanded(
                                                          child: AutoSizeText(
                                                            '${routingService.publicSteps[0].endAddress}',
                                                            maxLines: 2,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .caption,
                                                          ),
                                                        ),
                                                      ],
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
                                                      MainAxisAlignment
                                                          .spaceBetween,
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
                                                        !isEndUserNotificationWidgetOn)
                                                      Expanded(
                                                        child: AutoSizeText(
                                                          'Abholung durch ${step.provider.providerName}',
                                                        ),
                                                      ),
                                                    if (isEndUserNotificationWidgetOn)
                                                      Expanded(
                                                        child: AutoSizeText(
                                                          (routingService
                                                                      .sublinEndStep
                                                                      .confirmed ==
                                                                  false)
                                                              ? 'Wir benachrichten dich, sobald ${step.provider?.providerName} deine Abholung bestätigt hat.'
                                                              : routingService
                                                                          .sublinEndStep
                                                                          .completed ==
                                                                      false
                                                                  ? '${step.provider?.providerName} hat deine Abholung bestätigt.'
                                                                  : '${step.provider?.providerName} hat deine Abholung ab abgeschlossen.',
                                                        ),
                                                      ),
                                                    Expanded(
                                                      child: AutoSizeText(
                                                        '${getReadableAddressFromFormattedAddress(step.endAddress)}',
                                                        maxLines: 2,
                                                        style: ThemeConstants
                                                            .veryLargeHeader,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            if (direction == Direction.end &&
                                                routingService
                                                    .isPubliclyAccessibleEndAddress)
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
                                                  '${getTimeFormat(routingService.sublinStartStep.startTime - 1000 - routingService.sublinStartStep.duration)}',
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
                                                  '${getTimeFormat(routingService.publicSteps[0].startTime - 1200)}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .caption,
                                                  maxLines: 1,
                                                  textAlign: TextAlign.right,
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
                                                child: AutoSizeText(
                                                  '${getTimeFormat(routingService.sublinEndStep.endTime)}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline1,
                                                  maxLines: 2,
                                                  textAlign: TextAlign.right,
                                                ),
                                              ),
                                            if (direction == Direction.end &&
                                                routingService
                                                    .isPubliclyAccessibleEndAddress)
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
                              ]),
                        ),
                      ],
                    ),
                    StepIconWidget(
                      isSublinService: _isSublinService,
                      isStartAddress: direction == Direction.start,
                      isEndAddress: direction == Direction.end,
                      isWaitingForConfirmation: direction == Direction.start &&
                              isStartUserNotificationWidgetOn ||
                          direction == Direction.end &&
                              isEndUserNotificationWidgetOn,
                      icon: _isSublinService
                          ? Icons.directions_car
                          : Icons.directions_walk,
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
