import 'package:Sublin/models/address_info_class.dart';
import 'package:Sublin/models/my_card_format_enum.dart';
import 'package:Sublin/models/preferences_enum.dart';
import 'package:Sublin/models/request_class.dart';
import 'package:Sublin/models/routing_class.dart';
import 'package:Sublin/models/transportation_type_enum.dart';
import 'package:Sublin/models/user_class.dart';
import 'package:Sublin/screens/address_input_screen.dart';
import 'package:Sublin/screens/user_routing_screen.dart';
import 'package:Sublin/services/routing_service.dart';
import 'package:Sublin/services/shared_preferences_service.dart';
import 'package:Sublin/theme/theme.dart';
import 'package:Sublin/utils/get_icon_for_transportation_type.dart';
import 'package:Sublin/utils/get_readable_address_from_formatted_address.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class UserMySublinEndWidget extends StatelessWidget {
  const UserMySublinEndWidget(
      {Key key,
      @required this.addressInputCallback,
      @required this.removeRequestedAddressCallback,
      @required this.localRequest,
      this.addressInfo,
      @required this.itemWidth,
      @required this.itemHeight,
      @required this.user,
      @required this.context,
      @required this.myCardFormat,
      @required this.transportationType,
      @required this.isRouteBooked,
      this.onHeroTap})
      : super(key: key);

  final Function addressInputCallback;
  final Function removeRequestedAddressCallback;
  final Request localRequest;
  final AddressInfo addressInfo;
  final double itemWidth;
  final double itemHeight;
  final User user;
  final BuildContext context;
  final MyCardFormat myCardFormat;
  final VoidCallback onHeroTap;
  final TransportationType transportationType;
  final bool isRouteBooked;

  @override
  Widget build(BuildContext context) {
    return (() {
      switch (myCardFormat) {
        case MyCardFormat.available:
          return Container(
            height: itemHeight,
            width: itemWidth,
            child: Card(
                color: ThemeConstants.backgroundColor,
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Padding(
                  padding:
                      EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  shape: BoxShape.circle,
                                ),
                                child: getIconForTransportationType(
                                    addressInfo.transportationType)),
                            if (addressInfo.byProvider == false)
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () async {
                                  removeRequestedAddressCallback(
                                      addressInfo: addressInfo, user: user);
                                },
                              )
                          ],
                        ),
                      ),
                      Expanded(
                        child: AutoSizeText(
                          getReadableAddressFromFormattedAddress(
                              addressInfo.formattedAddress),
                          style: Theme.of(context).textTheme.headline2,
                          maxLines: 2,
                        ),
                      ),
                      if (addressInfo.transportationType ==
                          TransportationType.privat)
                        Expanded(
                          child: AutoSizeText(
                            'Von deiner Adresse zum Bahnhof gibt es derzeit leider keinen Sublin Service.',
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ),
                      if (addressInfo.transportationType ==
                          TransportationType.public)
                        Expanded(
                          child: AutoSizeText(
                            'Von dieser Adresse ist der öffentliche Verkehr erreichbar.',
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ),
                      if (addressInfo.transportationType ==
                          TransportationType.sublin)
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AutoSizeText(
                                'Bahnhof-Shuttle',
                                style: Theme.of(context).textTheme.caption,
                              ),
                              AutoSizeText(
                                'Gesponsert von',
                                style: Theme.of(context).textTheme.caption,
                                maxLines: 2,
                              ),
                              AutoSizeText(
                                addressInfo.sponsor,
                                style: Theme.of(context).textTheme.caption,
                                maxLines: 2,
                              ),
                            ],
                          ),
                        ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              flex: 2,
                              child: RaisedButton(
                                onPressed: (isRouteBooked)
                                    ? null
                                    : () async {
                                        String _startAddress =
                                            _getRequestBasedOnDirectionOfUser()
                                                .startAddress;
                                        String _endAddress =
                                            _getRequestBasedOnDirectionOfUser()
                                                .endAddress;

                                        addStringToSF(
                                            Preferences
                                                .stringLocalRequestStartAddress,
                                            _startAddress);
                                        addStringToSF(
                                            Preferences
                                                .stringLocalRequestEndAddress,
                                            _endAddress);
                                        await RoutingService().requestRoute(
                                          uid: user.uid,
                                          startAddress:
                                              _getRequestBasedOnDirectionOfUser()
                                                  .startAddress,
                                          startId: '',
                                          endAddress:
                                              _getRequestBasedOnDirectionOfUser()
                                                  .endAddress,
                                          endId: '',
                                          timestamp: DateTime.now(),
                                        );
                                        await Navigator.pushNamed(
                                          context,
                                          UserRoutingScreen.routeName,
                                          arguments: Routing(
                                            startId: '',
                                            endId: '',
                                          ),
                                        );
                                      },
                                child: Text('Hinfahren'),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )),
          );
          break;
        case MyCardFormat.add:
          return Container(
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddressInputScreen(
                              addressInputCallback: addressInputCallback,
                              userUid: user.uid,
                              user: user,
                              isEndAddress: true,
                              isStartAddress: false,
                              cityOnly: false,
                              title: 'Anderen Zielort suchen',
                            )));
              },
              child: Card(
                  color: ThemeConstants.backgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add,
                          size: 70,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        AutoSizeText(
                          'Anderen Zielort suchen',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )),
            ),
          );
        case MyCardFormat.unavailable:
          return Container(
            child: Card(
                color: Colors.white,
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Padding(
                  padding: ThemeConstants.mediumPadding,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          flex: 3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AutoSizeText(
                                'Für',
                                style: Theme.of(context).textTheme.caption,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              AutoSizeText(
                                addressInfo.sponsor,
                                style: Theme.of(context).textTheme.headline1,
                                maxLines: 2,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              AutoSizeText(
                                'gibt es leider noch keinen Sponsor',
                                style: Theme.of(context).textTheme.caption,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ))
                    ],
                  ),
                )),
          );
          break;
      }
    })();
  }

  Request _getRequestBasedOnDirectionOfUser() {
    Request request = Request();
    request.startAddress = localRequest.startAddress;
    request.endAddress = addressInfo.formattedAddress;
    return request;
  }
}
