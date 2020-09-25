import 'package:Sublin/models/address_info_class.dart';
import 'package:Sublin/models/direction_enum.dart';
import 'package:Sublin/models/my_card_format_enum.dart';
import 'package:Sublin/models/delimiter_class.dart';
import 'package:Sublin/models/preferences_enum.dart';
import 'package:Sublin/models/provider_plan_enum.dart';
import 'package:Sublin/models/provider_type_enum.dart';
import 'package:Sublin/models/provider_user.dart';
import 'package:Sublin/models/request_class.dart';
import 'package:Sublin/models/routing_class.dart';
import 'package:Sublin/models/transportation_type_enum.dart';
import 'package:Sublin/models/user_class.dart';
import 'package:Sublin/screens/address_input_screen.dart';
import 'package:Sublin/screens/user_routing_screen.dart';
import 'package:Sublin/services/routing_service.dart';
import 'package:Sublin/services/shared_preferences_service.dart';
import 'package:Sublin/services/user_service.dart';
import 'package:Sublin/theme/theme.dart';
import 'package:Sublin/utils/get_formatted_city_from_formatted_address.dart';
import 'package:Sublin/utils/get_formatted_city_from_provider_user_addresses.dart';
import 'package:Sublin/utils/get_icon_for_transportation_type.dart';
import 'package:Sublin/utils/get_readable_address_part_of_formatted_address.dart';
import 'package:Sublin/widgets/step_icon_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class UserMySublinCardWidget extends StatelessWidget {
  const UserMySublinCardWidget(
      {Key key,
      @required this.localRequest,
      this.providerUser,
      @required this.itemWidth,
      @required this.itemHeight,
      @required this.user,
      @required this.context,
      @required this.myCardFormat,
      @required this.transportationType,
      @required this.isRouteBooked,
      this.onHeroTap})
      : super(key: key);

  final Request localRequest;
  final ProviderUser providerUser;
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
    bool isShuttle = true;
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          flex: 3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    shape: BoxShape.circle,
                                  ),
                                  child: getIconForTransportationType(
                                      transportationType)),
                              SizedBox(height: 10),
                              if (isShuttle)
                                AutoSizeText(
                                  getReadableAddressPartOfFormattedAddress(
                                      providerUser.addresses[0],
                                      Delimiter.company),
                                  style: Theme.of(context).textTheme.headline1,
                                ),
                              if (!isShuttle)
                                AutoSizeText(
                                  getReadableAddressPartOfFormattedAddress(
                                      getFormattedCityFromListProviderUserAddresses(
                                          providerUser, user),
                                      Delimiter.city),
                                  style: Theme.of(context).textTheme.headline1,
                                ),
                              AutoSizeText(
                                'Bahnhof-Shuttle',
                                style: Theme.of(context).textTheme.caption,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              AutoSizeText(
                                'Gesponsert von',
                                style: Theme.of(context).textTheme.caption,
                              ),
                              Expanded(
                                child: AutoSizeText(
                                  providerUser.providerName,
                                  style: Theme.of(context).textTheme.caption,
                                  maxLines: 2,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: RaisedButton(
                                      onPressed: (isRouteBooked)
                                          ? null
                                          : () async {
                                              if (localRequest?.startAddress !=
                                                  '') {
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
                                                await RoutingService()
                                                    .requestRoute(
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
                                              } else {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            AddressInputScreen(
                                                              userUid: user.uid,
                                                              addressInputCallback:
                                                                  _addressInputFunction,
                                                              isEndAddress:
                                                                  false,
                                                              isStartAddress:
                                                                  true,
                                                              showGeolocationOption:
                                                                  false,
                                                              isStation: false,
                                                              title:
                                                                  'Dein Standort',
                                                            )));
                                              }
                                            },
                                      child: Text('Hinfahren'),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ))
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
                              addressInputCallback:
                                  _addCityToCommunesSelectionCallback,
                              userUid: user.uid,
                              isEndAddress: false,
                              isStartAddress: false,
                              cityOnly: false,
                              title: 'Zielort suchen',
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
                                providerUser.providerName,
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

  // String _getMostSpecificAddressForRequest() {
  //   String _mostSpecificAddress = '';
  //   if (providerUser.providerType == ProviderType.shuttle ||
  //       providerUser.providerType == ProviderType.sponsorShuttle) {
  //     _mostSpecificAddress = providerUser.addresses[0];
  //   }
  //   return '';
  // }

  Request _getRequestBasedOnDirectionOfUser() {
    Request request = Request();
    request.startAddress = localRequest.startAddress;
    request.endAddress = providerUser.addresses[0];

    // if (_getDirectionBasedUserPosition() == Direction.end) {
    // } else {
    //   // If it is a specific address we need this one - if it is a city address we use the users position
    //   if (providerUser.addresses
    //       .contains(getCityFormattedAddress(localRequest.startAddress)))
    //     request.startAddress = localRequest.startAddress;
    //   else
    //     request.startAddress = providerUser.addresses[0];
    // }
    return request;
  }

  Direction _getDirectionBasedUserPosition() {
    Direction _direction = Direction.end;
    if (providerUser.communes.contains(
        getFormattedCityFromFormattedAddress(localRequest.startAddress)))
      _direction = Direction.start;
    return _direction;
  }

  void _addCityToCommunesSelectionCallback({
    String userUid,
    String input,
    String id,
    bool isCompany,
    bool isStartAddress,
    bool isEndAddress,
    ProviderUser providerUser,
    String station,
    AddressInfo addressInfo,
  }) async {
    User _data;
    _data = await UserService().getUser(userUid);
    if (!_data.communes.contains(input)) {
      _data.communes.add(input);
    }
    await UserService().writeUserData(uid: userUid, data: _data);
  }

  Future<void> _addressInputFunction({
    String userUid,
    String input,
    String id,
    bool isCompany,
    List<dynamic> terms,
    bool isStartAddress,
    bool isEndAddress,
    ProviderUser providerUser,
    String station,
    AddressInfo addressInfo,
  }) async {
    // setState(() {
    //   _localRequest.startAddress = input;
    // });
    addStringToSF(Preferences.stringLocalRequestStartAddress, input);
  }
}
