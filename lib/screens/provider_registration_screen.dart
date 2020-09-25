import 'dart:async';

import 'package:Sublin/utils/add_city_to_communes_and_addresses.dart';
import 'package:Sublin/utils/get_formatted_station_from_formatted_address.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:Sublin/models/delimiter_class.dart';
import 'package:Sublin/models/user_type_enum.dart';
import 'package:Sublin/screens/provider_booking_screen.dart';
import 'package:Sublin/services/user_service.dart';
import 'package:Sublin/utils/add_string_to_list.dart';
import 'package:Sublin/utils/get_formatted_city_from_formatted_address.dart';
import 'package:Sublin/utils/get_readable_address_part_of_formatted_address.dart';
import 'package:Sublin/widgets/appbar_widget.dart';
import 'package:Sublin/models/auth_class.dart';
import 'package:Sublin/models/provider_plan_enum.dart';
import 'package:Sublin/models/provider_type_enum.dart';
import 'package:Sublin/models/provider_user.dart';
import 'package:Sublin/models/request_class.dart';
import 'package:Sublin/models/routing_class.dart';
import 'package:Sublin/models/timespan_enum.dart';
import 'package:Sublin/models/user_class.dart';
import 'package:Sublin/screens/address_input_screen.dart';
import 'package:Sublin/screens/email_list_screen.dart';
import 'package:Sublin/services/provider_user_service.dart';
import 'package:Sublin/services/routing_service.dart';
import 'package:Sublin/widgets/address_search_widget.dart';
import 'package:Sublin/widgets/time_field_widget.dart';
import 'package:Sublin/widgets/progress_indicator_widget.dart';
import 'package:Sublin/widgets/provider_selection_widget.dart';

enum SingingCharacter { provider, service }

class ProviderRegistrationScreen extends StatefulWidget {
  static const routeName = '/providerRegistrationScreen';
  @override
  _ProviderRegistrationScreenState createState() =>
      _ProviderRegistrationScreenState();
}

class _ProviderRegistrationScreenState
    extends State<ProviderRegistrationScreen> {
  PageController _pageViewController = PageController(initialPage: 0);
  TextEditingController _providerNameFormFieldController =
      TextEditingController();
  // _providerUser is the object that we will fill with user data
  ProviderUser _providerUser = ProviderUser();
  // We need an instance to check if fields are already provided
  ProviderUser _defaultProviderUser = ProviderUser();
  Routing _defaultValueRouting = Routing();
  // We check if there is already taxi service available for the user address
  Routing _checkRoutingData;
  // We make a dummy request which is marked as check
  Request _request = Request();
  bool _showProgressIndicator = false;
  String _previousDataId;
  // Button active or disabled
  bool _addressFound = false;
  StreamSubscription<Routing> _routingStream;
  int _pageSteps = 1;
  // This is the station information coming from the autocomplete. We need to format it before we can save it to _providerUser
  String _station = '';

  DateFormat format = DateFormat('HHmm');
  var time = DateTime.parse("1969-07-20 20:18:04Z");

  @override
  void initState() {
    super.initState();
    _previousDataId = _defaultValueRouting.id;
    // Dummy address to calculate route
    _request.startAddress =
        'Wien Hauptbahnhof, Wien Südbahnhof, Am Hauptbahnhof, Vienna, Austria';
    _request.startId = 'ChIJUU071tupbUcRyFdx20Nwgqg';
    _request.endAddress = '';
    _request.endId = '';
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    // _routingStream ?? _routingStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Auth auth = Provider.of<Auth>(context);
    final User user = Provider.of<User>(context);

    print(ProviderUser().toMap(_providerUser));

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: AppbarWidget(
            title: user.userType == UserType.provider
                ? 'Registrierung als Anbieter'
                : 'Registrierung als Sponsor',
          )),
      body: SafeArea(
        child: PageView(
          controller: _pageViewController,
          children: <Widget>[
            // First Page ------------------------------- 1 ----------------------------------
            // 1. 'addressInputFunction' sets the 'communes' field of the '_userProvider' object
            // 2. when the user clicks the button a call to RoutingService().requestRoute is sent that
            // triggers a 'routing' service in the backend
            // 3. '_checkAddressStatus opens a stream 'RoutingService().streamCheck(uid)' to check for the route in the 'check' collection of the database
            Container(
              child: Column(
                children: <Widget>[
                  ProgressIndicatorWidget(
                    index: 1,
                    elements: 4,
                    showProgressIndicator: _showProgressIndicator,
                  ),
                  Padding(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Hallo ' + user.firstName,
                                style: Theme.of(context).textTheme.headline3,
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          AutoSizeText(
                            user.userType == UserType.provider
                                ? 'Super, du hast dich als Anbieter registriert. Wir benötigen noch ein paar Informationen von dir, damit wir deine Registrierung bearbeiten können.'
                                : 'Super, du hast dich als Sponsor angemeldet. Du kannst kannst jetzt deine Art der Unterstützung nach deinen Wünschen anpassen, wie z.B. örtliche oder zielgruppenspezifischen Einschränkungen.',
                            style: Theme.of(context).textTheme.bodyText1,
                            maxLines: 8,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          AddressSearchWidget(
                            addressInputFunction: _addressSelectionFunction,
                            isEndAddress: true,
                            isStartAddress: false,
                            isCheckOnly: true,
                            addressTypes: 'establishment&city_hall',
                            address: _request.endAddress,
                            endHintText: 'Deine Betriebssadresse',
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              RaisedButton(
                                onPressed: (_addressFound)
                                    ? () async {
                                        try {
                                          setState(() {
                                            _providerNameFormFieldController
                                                .text = '';
                                            _station = '';
                                            _showProgressIndicator = true;
                                            _providerUser = ProviderUser();
                                            _providerUser.addresses = [
                                              _request.endAddress
                                            ];
                                          });
                                          // Create a route to check if there is service at the end address
                                          await RoutingService().requestRoute(
                                            uid: auth.uid,
                                            startAddress: _request.startAddress,
                                            startId: _request.startId,
                                            endAddress: _request.endAddress,
                                            endId: _request.endId,
                                            checkAddress:
                                                true, // checking only address to see if a service is available
                                            timestamp: DateTime.now()
                                                .millisecondsSinceEpoch,
                                          );
                                          await _checkAddressStatus(auth.uid);
                                        } catch (e) {}
                                      }
                                    : null,
                                child: Text('Weiter'),
                              )
                            ],
                          )
                        ],
                      )),
                ],
              ),
            ),
            // Second Page ------------------------------- 2 ----------------------------------
            if (_pageSteps >= 2)
              SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  // padding: EdgeInsets.all(15),
                  child: Column(
                    children: <Widget>[
                      ProgressIndicatorWidget(
                        index: 2,
                        elements: 4,
                        showProgressIndicator: _showProgressIndicator,
                      ),
                      Padding(
                          padding: EdgeInsets.all(15),
                          child: Column(
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Grüße nach ${getReadableAddressPartOfFormattedAddress(_checkRoutingData.endAddress, Delimiter.city)}',
                                    style:
                                        Theme.of(context).textTheme.headline3,
                                    textAlign: TextAlign.left,
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  if (!_checkRoutingData.endAddressAvailable)
                                    Text(
                                        'Für ${getReadableAddressPartOfFormattedAddress(_checkRoutingData.endAddress, Delimiter.city)} hat sich noch kein Taxi- oder Mietwagenunternehmen registriert.'),
                                  if (_checkRoutingData.endAddressAvailable)
                                    Text(
                                        '${_checkRoutingData.sublinEndStep.provider.providerName} hat sich bereits für ${getReadableAddressPartOfFormattedAddress(_checkRoutingData.endAddress, Delimiter.city)} registriert und führt voraussichtlich Shuttleservice vom und zum Bahnhof durch.'),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  AutoSizeText(
                                    'Bitte wähle die Leistung an, die du anbieten möchtest.',
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  if (_checkRoutingData.endAddressAvailable &&
                                      user.userType == UserType.sponsor)
                                    ProviderSelectionWidget(
                                      title:
                                          'Zwischen Bahnhof und deiner Betriebsaddresse',
                                      text: user.userType == UserType.provider
                                          ? 'Transfers werden zwischen deiner Address und dem Bahnhof von ${_checkRoutingData.sublinEndStep.provider.providerName} durchgeführt.'
                                          : '${_checkRoutingData.sublinEndStep.provider.providerName} führt Transfers zwischen dem Bahnhof und den Privatadressen des Gemeindegebiets ${getReadableAddressPartOfFormattedAddress(_checkRoutingData.endAddress, Delimiter.city)} durch.',
                                      caption: '',
                                      providerTypeSelection:
                                          ProviderType.sponsorShuttle,
                                      selectionFunction:
                                          _providerSelectionFunction,
                                      active: ProviderType.sponsorShuttle ==
                                          _providerUser.providerType,
                                    ),
                                  if (_checkRoutingData.endAddressAvailable &&
                                      user.userType == UserType.sponsor)
                                    ProviderSelectionWidget(
                                      title:
                                          'Gesamtes Gemeindegebiet ${getReadableAddressPartOfFormattedAddress(_checkRoutingData.endAddress, Delimiter.city)}',
                                      text: user.userType == UserType.provider
                                          ? 'Du übernimmst die Kosten für Transfers zwischen dem Bahnhof von ${_checkRoutingData.sublinEndStep.provider.providerName} durchgeführt.'
                                          : '${_checkRoutingData.sublinEndStep.provider.providerName} führt Transfers zwischen dem Bahnhof und den Privatadressen des Gemeindegebiets ${getReadableAddressPartOfFormattedAddress(_checkRoutingData.endAddress, Delimiter.city)} durch.',
                                      caption: '',
                                      providerTypeSelection:
                                          ProviderType.sponsor,
                                      selectionFunction:
                                          _providerSelectionFunction,
                                      active: ProviderType.sponsor ==
                                          _providerUser.providerType,
                                    ),
                                  if (!_checkRoutingData.endAddressAvailable)
                                    ProviderSelectionWidget(
                                      title: 'Taxi- oder Mietwagenservice',
                                      text:
                                          'vom Bahnhof zu den Adressen in ${getReadableAddressPartOfFormattedAddress(_checkRoutingData.endAddress, Delimiter.city)}. Gewerbeberechtigung notwendig.',
                                      providerTypeSelection: ProviderType.taxi,
                                      selectionFunction:
                                          _providerSelectionFunction,
                                      active: ProviderType.taxi ==
                                          _providerUser.providerType,
                                    ),
                                  if (user.userType == UserType.provider)
                                    ProviderSelectionWidget(
                                      title: 'Shuttleservice',
                                      text: user.userType == UserType.provider
                                          ? 'Du bietest ein Shuttleservice zwischen Bahnhof und deiner Adresse an.'
                                          : '${getReadableAddressPartOfFormattedAddress(_checkRoutingData.endAddress, Delimiter.company)} bietet ein eigenes Transferservice zwischen Bahnhof und den Privatadressen des Gemeindegebiets ${getReadableAddressPartOfFormattedAddress(_checkRoutingData.endAddress, Delimiter.city)} durch.',
                                      providerTypeSelection:
                                          ProviderType.shuttle,
                                      selectionFunction:
                                          _providerSelectionFunction,
                                      active: ProviderType.shuttle ==
                                          _providerUser.providerType,
                                    ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  RaisedButton(
                                    onPressed: _providerUser.providerType !=
                                            null
                                        ? () {
                                            // Add the taxi partner
                                            _providerUser.partners =
                                                _providerUser.providerType ==
                                                            ProviderType
                                                                .sponsor ||
                                                        _providerUser
                                                                .providerType ==
                                                            ProviderType
                                                                .sponsorShuttle
                                                    ? [
                                                        _checkRoutingData
                                                            .sublinEndStep
                                                            .provider
                                                            .id
                                                      ]
                                                    : [];
                                            // If sponsor than add the city address

                                            String cityFormattedAddress =
                                                getFormattedCityFromFormattedAddress(
                                                    _checkRoutingData
                                                        .endAddress);
                                            if (_providerUser.providerType ==
                                                ProviderType.sponsor)
                                              setState(() {
                                                _providerUser =
                                                    addCityToCommunesAndAddresses(
                                                        providerUser:
                                                            _providerUser,
                                                        cityFormattedAddress:
                                                            getFormattedCityFromFormattedAddress(
                                                                _checkRoutingData
                                                                    .endAddress));
                                              });

                                            // if (_providerUser.providerType ==
                                            //         ProviderType.sponsor &&
                                            //     cityFormattedAddress != '' &&
                                            //     !_providerUser.addresses
                                            //         .contains(
                                            //             cityFormattedAddress))

                                            //   _providerUser.addresses.add(
                                            //       getReadableCityFormattedAddress(
                                            //           _checkRoutingData
                                            //               .endAddress));

                                            _pageViewController.nextPage(
                                                duration:
                                                    Duration(milliseconds: 300),
                                                curve: Curves.easeOut);
                                          }
                                        : null,
                                    child: Text('Weiter'),
                                  )
                                ],
                              )
                            ],
                          )),
                    ],
                  ),
                ),
              ),
            // Second Page ------------------------------- 3 ----------------------------------
            if (_pageSteps >= 3)
              SingleChildScrollView(
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      // padding: EdgeInsets.all(15),
                      child: Column(
                        children: <Widget>[
                          ProgressIndicatorWidget(
                            index: 3,
                            elements: 4,
                            showProgressIndicator: _showProgressIndicator,
                          ),
                          Padding(
                              padding: EdgeInsets.all(15),
                              child: Column(children: <Widget>[
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Noch ein paar Details zu deinem Unternehmen',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline3,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      AutoSizeText(
                                        'Wie lautet dein Unternehmensname?',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Card(
                                        child: Padding(
                                          padding: const EdgeInsets.all(15),
                                          child: Column(children: <Widget>[
                                            TextFormField(
                                                validator: (val) => val.length <
                                                        3
                                                    ? 'Bitte gib hier deinen Unternehmensnamen ein'
                                                    : null,
                                                controller:
                                                    _providerNameFormFieldController,
                                                onChanged: (val) {
                                                  setState(() {
                                                    _providerUser.providerName =
                                                        val;
                                                  });
                                                },
                                                decoration: InputDecoration(
                                                  hintText:
                                                      'Dein Unternehmensname',
                                                  prefixIcon: Icon(
                                                      Icons.account_circle,
                                                      color: Theme.of(context)
                                                          .accentColor),
                                                )),
                                          ]),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      AutoSizeText(
                                        'Zu welchen Uhrzeiten bietest du deine Leistungen an? Du kannst das Services jederzeit aussetzen.',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      GestureDetector(
                                        onTap: () => null, // _pickTime(),
                                        child: Card(
                                          child: Padding(
                                            padding: const EdgeInsets.all(15),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Flexible(
                                                    flex: 1,
                                                    child: Text('Von')),
                                                Flexible(
                                                    flex: 2,
                                                    child: TimeFildWidget(
                                                      initalTime:
                                                          _fromIntToDateTime(
                                                              _providerUser
                                                                  .timeStart),
                                                      timespan: Timespan.start,
                                                      timeInputCallback:
                                                          _fromDateTimeToInt,
                                                    )),
                                                Flexible(
                                                    flex: 1,
                                                    child: Text('bis')),
                                                Flexible(
                                                    flex: 2,
                                                    child: TimeFildWidget(
                                                      initalTime:
                                                          _fromIntToDateTime(
                                                              _providerUser
                                                                  .timeEnd),
                                                      timespan: Timespan.end,
                                                      timeInputCallback:
                                                          _fromDateTimeToInt,
                                                    ))
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          RaisedButton(
                                            onPressed:
                                                (_providerUser.providerName !=
                                                        _defaultProviderUser
                                                            .providerName)
                                                    ? () async {
                                                        try {
                                                          _providerNameFormFieldController
                                                                  .text =
                                                              _providerUser
                                                                  .providerName;
                                                          setState(() {
                                                            _pageSteps = _providerUser
                                                                            .providerType ==
                                                                        ProviderType
                                                                            .sponsor ||
                                                                    _providerUser
                                                                            .providerType ==
                                                                        ProviderType
                                                                            .sponsorShuttle
                                                                ? 5
                                                                : 4;
                                                          });
                                                          _pageViewController.nextPage(
                                                              duration: Duration(
                                                                  milliseconds:
                                                                      300),
                                                              curve: Curves
                                                                  .easeOut);
                                                        } catch (e) {
                                                          print(e);
                                                        }
                                                      }
                                                    : null,
                                            child: Text('Weiter'),
                                          )
                                        ],
                                      )
                                    ])
                              ])),
                        ],
                      ))),
            // Fourth Page ------------------------------- 4 ----------------------------------
            if (_providerUser.providerType == ProviderType.taxi &&
                    _pageSteps >= 3 ||
                _providerUser.providerType == ProviderType.shuttle &&
                    _pageSteps >= 4)
              SingleChildScrollView(
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      // padding: EdgeInsets.all(15),
                      child: Column(children: <Widget>[
                        ProgressIndicatorWidget(
                          index: 4,
                          elements: 4,
                          showProgressIndicator: _showProgressIndicator,
                        ),
                        Padding(
                            padding: EdgeInsets.all(15),
                            child: Column(children: <Widget>[
                              Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Gleich hast du es geschafft',
                                      style:
                                          Theme.of(context).textTheme.headline3,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    AutoSizeText(
                                      'Für welchen Bahnhof bietest du deine Shuttleservice an?',
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    AddressSearchWidget(
                                      addressInputFunction:
                                          _stationSelectionFunction,
                                      isEndAddress: false,
                                      isStartAddress: false,
                                      isStation: true,
                                      isCheckOnly: true,
                                      restrictions: 'Bahnhof',
                                      address: _station,
                                      endHintText: 'Dein Bahnhof',
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    if (_providerUser.stations.length > 0 &&
                                        _providerUser.providerType ==
                                            ProviderType.taxi)
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          AutoSizeText(
                                            'Du bietest deinen Shuttleservice für folgende Ortschaften an:',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          _getCitiesFromStationsWidget(
                                              _providerUser.stations),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: <Widget>[
                                              Container(
                                                child: FlatButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  AddressInputScreen(
                                                                    addressInputCallback:
                                                                        _citySelectionFunction,
                                                                    isEndAddress:
                                                                        false,
                                                                    isStartAddress:
                                                                        false,
                                                                    cityOnly:
                                                                        true,
                                                                    title:
                                                                        'Ortschaft hinzufügen',
                                                                  )));
                                                    },
                                                    child: Text(
                                                        'Weitere Ortschaften Hinzufügen')),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    if (_providerUser.providerType ==
                                        ProviderType.taxi)
                                      RegisterNowWidget(
                                        user: user,
                                        providerUser: _providerUser,
                                        auth: auth,
                                        isActive:
                                            _providerUser.stations.length > 0,
                                      ),
                                    if (_providerUser.providerType ==
                                        ProviderType.shuttle)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          RaisedButton(
                                            onPressed: (_providerUser
                                                        .stations.length !=
                                                    0)
                                                ? () async {
                                                    try {
                                                      _pageSteps = 4;
                                                      // Add To communes
                                                      _providerUser.communes =
                                                          addStringToList(
                                                              _providerUser
                                                                  .communes,
                                                              getFormattedCityFromFormattedAddress(
                                                                  _providerUser
                                                                          .addresses[
                                                                      0]));
                                                      _pageViewController
                                                          .nextPage(
                                                              duration: Duration(
                                                                  milliseconds:
                                                                      300),
                                                              curve: Curves
                                                                  .easeOut);
                                                    } catch (e) {}
                                                  }
                                                : null,
                                            child: Text('Weiter'),
                                          ),
                                        ],
                                      )
                                  ])
                            ]))
                      ]))),
            // Fourth Page ------------------------------- 4 ----------------------------------
            if (_pageSteps >= 4 &&
                    _providerUser.providerType == ProviderType.shuttle ||
                _providerUser.providerType == ProviderType.sponsor ||
                _providerUser.providerType == ProviderType.sponsorShuttle)
              SingleChildScrollView(
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    // padding: EdgeInsets.all(15),
                    child: Column(children: <Widget>[
                      ProgressIndicatorWidget(
                        index: 4,
                        elements: 4,
                        showProgressIndicator: _showProgressIndicator,
                      ),
                      Padding(
                          padding: EdgeInsets.all(15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Zum Schluss noch deine Zielgruppe',
                                style: Theme.of(context).textTheme.headline3,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              AutoSizeText(
                                'Wer kann Shuttleservices in Anspruch nehmen?',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              ProviderSelectionWidget(
                                title: 'Nur bestimmte Personen',
                                text:
                                    'Nur Personen mit einer bestimmten E-Mail-Adressen. Du kannst jederzeit E-Mails hinzufügen oder entfernen',
                                buttonFunction: ProviderPlan.emailOnly ==
                                        _providerUser.providerPlan
                                    ? pushToEmailListScreen
                                    : null,
                                buttonText:
                                    _providerUser.targetGroup.length == 0
                                        ? 'E-Mails hinzufügen'
                                        : 'E-Mails verwalten',
                                providerPlanSelection: ProviderPlan.emailOnly,
                                selectionFunction:
                                    _providerPlanSelectionFunction,
                                active: ProviderPlan.emailOnly ==
                                    _providerUser.providerPlan,
                              ),
                              ProviderSelectionWidget(
                                title: 'Alle',
                                text: user.userType == UserType.provider
                                    ? 'Alle Personen, die den Service zwischen Bahnhof und deiner Address in ${getReadableAddressPartOfFormattedAddress(_providerUser.addresses[0], Delimiter.city)} beautragen.'
                                    : 'Alle Personen, die den Transferservice zwischen Bahnhof und den Adressen des Gemeindegebiets ${getReadableAddressPartOfFormattedAddress(_providerUser.addresses[0], Delimiter.city)} beauftragen',
                                providerPlanSelection: ProviderPlan.all,
                                selectionFunction:
                                    _providerPlanSelectionFunction,
                                active: ProviderPlan.all ==
                                    _providerUser.providerPlan,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  RaisedButton(
                                    onPressed: _providerUser.providerPlan ==
                                                    ProviderPlan.emailOnly &&
                                                _providerUser
                                                        .targetGroup.length >
                                                    0 ||
                                            _providerUser.providerPlan ==
                                                ProviderPlan.all
                                        ? () async {
                                            _providerUser.operationRequested =
                                                true;
                                            await ProviderUserService()
                                                .updateProviderUserData(
                                                    uid: auth.uid,
                                                    data: _providerUser);
                                            User _user = user;
                                            _user.isRegistrationCompleted =
                                                true;
                                            await UserService()
                                                .updateUserDataIsRegistrationCompleted(
                                                    uid: user.uid);
                                            await Navigator.pushNamed(
                                                context,
                                                ProviderBookingScreen
                                                    .routeName);
                                          }
                                        : null,
                                    child: Text('Jetzt registrieren'),
                                  )
                                ],
                              )
                            ],
                          ))
                    ])),
              ),
          ],
        ),
      ),
    );
  }

  Future pushToEmailListScreen(BuildContext context) {
    // _providerUser.targetGroup = ['andreas.schadauer'];
    return Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EmailListScreen(
                  emailListScreenFunction: _emailListScreenFunction,
                  targetGroup: _providerUser.targetGroup,
                )));
  }

  void _emailListScreenFunction(List<String> list) {
    setState(() {
      _providerUser.targetGroup = list;
    });
  }

  void _providerPlanSelectionFunction(ProviderPlan selection) {
    setState(() {
      _providerUser.providerPlan = selection;
    });
  }

  void _providerSelectionFunction(ProviderType selection) {
    setState(() {
      _providerUser.providerType = selection;
      _pageSteps = 3;
    });
  }

  void _addressSelectionFunction({
    String userUid,
    String input,
    String id,
    bool isCompany,
    bool isStartAddress,
    bool isEndAddress,
    ProviderUser providerUser,
    String station,
  }) {
    setState(() {
      _addressFound = true;
      _request.endAddress = input;
      _request.endId = id;
    });
  }

  void _stationSelectionFunction({
    String userUid,
    String input,
    String id,
    bool isCompany,
    bool isStartAddress,
    bool isEndAddress,
    ProviderUser providerUser,
    String station,
  }) {
    _station = input;
    _setStationFromProviderAddressFunction(
      station: _station,
      delimiter: Delimiter.city,
    );
  }

  void _citySelectionFunction({
    String userUid,
    String input,
    String id,
    bool isCompany,
    bool isStartAddress,
    bool isEndAddress,
    ProviderUser providerUser,
    String station,
  }) {
    _addCityToStations(input);
  }

  void _addCityToStations(String formattedAddress) {
    bool cityExists = false;
    _providerUser.stations.map((station) {
      String cityFromFormattedAddress =
          getFormattedCityFromFormattedAddress(formattedAddress);
      String cityFromStation = getFormattedCityFromFormattedAddress(station);

      if (cityFromFormattedAddress == cityFromStation) {
        cityExists = true;
      }
    }).toList();
    if (cityExists == false) {
      setState(() {
        _providerUser.stations.add(formattedAddress + _station);
        _providerUser.communes =
            addStringToList(_providerUser.communes, formattedAddress);
      });
    }
  }

  Future<void> _checkAddressStatus(String uid) async {
    try {
      final myStream = RoutingService().streamCheck(uid);
      _routingStream = myStream.listen((data) {
        if (data.id != _defaultValueRouting.id && data.id != _previousDataId) {
          setState(() {
            _checkRoutingData = data;
            _showProgressIndicator = false;
            _pageSteps = 2;
            _pageViewController.nextPage(
                duration: Duration(milliseconds: 300), curve: Curves.easeOut);
          });
          _previousDataId = data.id;
          RoutingService().deleteCheck(uid);
          //_routingStream.cancel();
        }
      });
    } catch (e) {
      print(e);
    }
  }

  void _setStationFromProviderAddressFunction({
    String delimiter = Delimiter.city,
    String station = '',
    bool remove = false,
  }) {
    String userAddress = _providerUser.addresses[0];
    // If Taxi the scope is the postcode
    // If not Taxi the scope is the full address
    if (_providerUser.providerType == ProviderType.taxi)
      userAddress =
          getFormattedCityFromFormattedAddress(_providerUser.addresses[0]);
    setState(() {
      _providerUser.stations =
          addStringToList(_providerUser.stations, userAddress + station);
      // Get the formatted city for the communes
      _providerUser.communes = addStringToList(_providerUser.communes,
          getFormattedCityFromFormattedAddress(userAddress));
      // _providerUser.addresses.add(userAddress);
    });
  }

  void _removeCityFromStation(String city) {
    setState(() {
      int removeIndex;
      for (var i = 0; i < _providerUser.stations.length; i++) {
        String cityFromAddress = getReadableAddressPartOfFormattedAddress(
            _providerUser.stations[i], Delimiter.city);
        if (city == cityFromAddress) {
          removeIndex = i;
        }
      }
      _providerUser.stations.removeAt(removeIndex);
    });
  }

  void _fromDateTimeToInt(Timespan timespan, DateTime time) {
    if (timespan == Timespan.start) {
      setState(() {
        _providerUser.timeStart = int.parse(format.format(time));
      });
    } else if (timespan == Timespan.end) {
      setState(() {
        _providerUser.timeEnd = int.parse(format.format(time));
      });
    }
  }

  DateTime _fromIntToDateTime(int time) {
    int timeInt = time ?? 0;
    String timeString = timeInt.toString();
    for (var i = timeString.length; i < 4; i++) {
      timeString = '0' + timeString;
    }
    timeString = timeString.substring(0, 2) + ':' + timeString.substring(2, 4);
    DateTime timeDate = DateTime.parse('2020-01-01 ' + timeString + ':00');
    return timeDate;
  }

  Widget _getCitiesFromStationsWidget(List<String> communes) {
    if (communes != null && communes.length > 0) {
      return Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.spaceBetween,
          spacing: 8.0,
          children: communes.map((address) {
            String city = getReadableAddressPartOfFormattedAddress(
                address, Delimiter.city);
            return Chip(
              label: Text(city),
              onDeleted: city ==
                      getReadableAddressPartOfFormattedAddress(
                          _providerUser.communes[0], Delimiter.city)
                  ? null
                  : () => _removeCityFromStation(city),
            );
          }).toList());
    } else {
      return Wrap();
    }
  }
}

class RegisterNowWidget extends StatelessWidget {
  const RegisterNowWidget(
      {Key key,
      @required ProviderUser providerUser,
      @required this.user,
      @required this.auth,
      @required this.isActive})
      : _providerUser = providerUser,
        super(key: key);

  final ProviderUser _providerUser;
  final Auth auth;
  final bool isActive;
  final User user;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        RaisedButton(
          onPressed: isActive
              ? () async {
                  _providerUser.operationRequested = true;
                  await ProviderUserService().updateProviderUserData(
                      uid: auth.uid, data: _providerUser);
                  User _user = user;
                  _user.isRegistrationCompleted = true;
                  await UserService()
                      .updateUserDataIsRegistrationCompleted(uid: user.uid);
                  await Navigator.pushNamed(
                      context, ProviderBookingScreen.routeName);
                }
              : null,
          child: Text('Jetzt registrieren'),
        )
      ],
    );
  }
}
