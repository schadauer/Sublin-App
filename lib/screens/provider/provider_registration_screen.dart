import 'dart:async';

import 'package:Sublin/services/google_map_service.dart';
import 'package:Sublin/utils/format_address.dart';
import 'package:Sublin/utils/get_part_of_address.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:Sublin/models/auth.dart';
import 'package:Sublin/models/provider_plan.dart';
import 'package:Sublin/models/provider_type.dart';
import 'package:Sublin/models/provider_user.dart';
import 'package:Sublin/models/request.dart';
import 'package:Sublin/models/routing.dart';
import 'package:Sublin/models/timespan.dart';
import 'package:Sublin/models/user.dart';
import 'package:Sublin/screens/address_input_screen.dart';
import 'package:Sublin/screens/email_list_screen.dart';
import 'package:Sublin/services/auth_service.dart';
import 'package:Sublin/services/provider_user_service.dart';

import 'package:Sublin/services/routing_service.dart';
import 'package:Sublin/widgets/address_search_widget.dart';
import 'package:Sublin/widgets/drawer_side_navigation_widget.dart';
import 'package:Sublin/widgets/input/time_field_widget.dart';
import 'package:Sublin/widgets/progress_indicator_widget.dart';
import 'package:Sublin/widgets/provider/provider_selection_widget.dart';

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
  TextEditingController _stationFormFieldController = TextEditingController();
  TextEditingController _postcodeFormFieldController = TextEditingController();
  // _providerUser is the object that we will fill with user data
  ProviderUser _providerUser = ProviderUser();
  ProviderUser _defaultProviderUser = ProviderUser();
  Routing _defaultValueRouting = Routing();
  Routing _checkRoutingData;
  Request _request = Request();
  bool _showProgressIndicator = false;
  String _previousDataId;
  // Button active or disabled
  bool _addressFound = false;
  StreamSubscription<Routing> _subscription;
  int _pageSteps = 1;
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
    print('dispose');
    _pageViewController.dispose();
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Auth auth = Provider.of<Auth>(context);
    final User user = Provider.of<User>(context);
    // final providerUser = Provider.of<ProviderUser>(context);

    print(ProviderUser().toMap(_providerUser));
    // print(ProviderUser().toMap(_defaultProviderUser));

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          title: Text('Registrierung als Anbieter'),
          elevation: 0.0,
          backgroundColor: Theme.of(context).primaryColor,
          leading: Image.asset(
            'assets/images/Sublin.png',
            scale: 1.3,
          ),
        ),
      ),
      endDrawer: DrawerSideNavigationWidget(
        authService: AuthService(),
      ),
      body: SafeArea(
        child: PageView(
          controller: _pageViewController,
          children: <Widget>[
            // First Page ------------------------------- 1 ----------------------------------
            // 1. 'addressInputFunction' sets the 'addresses' field of the '_userProvider' object
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
                            'Super, du hast dich als Anbieter registriert. Wir benötigen noch ein paar Informationen von dir, damit wir deine Registrierung bearbeiten können.',
                            style: Theme.of(context).textTheme.bodyText1,
                            maxLines: 8,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          AddressSearchWidget(
                            addressInputFunction: addressSelectionFunction,
                            isEndAddress: true,
                            isStartAddress: false,
                            isCheckOnly: true,
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
                                            _showProgressIndicator = true;
                                            _providerUser = ProviderUser();
                                            _providerUser.addresses = [
                                              formatAddress(_request.endAddress)
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

                                          // At the moment only one address is possible
                                          // Format of address is [street]__[postcode]
                                          // String
                                          //     formattedAddressWithGooglePlace =
                                          //     await (GoogleMapService()
                                          //         .getFormattedAddressWithGooglePlace(
                                          //             _request.endId));
                                          // _providerUser.addresses = [
                                          //   formattedAddressWithGooglePlace
                                          // ];
                                          await _checkAddressStatus(auth.uid);
                                          // Also set the first postcode - this is the postcode of the provider's address -
                                          // Strips the postcode part of the address
                                          // _providerUser.postcodes = [
                                          //   formatAddress(_request.endAddress)
                                          // ];
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
                                    'Grüße nach ${_checkRoutingData.endAddress.city}',
                                    style:
                                        Theme.of(context).textTheme.headline3,
                                    textAlign: TextAlign.left,
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  if (!_checkRoutingData.endAddressAvailable)
                                    Text(
                                        'Für ${_checkRoutingData.endAddress.city} hat sich noch kein Taxi- oder Mietwagenunternehmen registriert.'),
                                  if (_checkRoutingData.endAddressAvailable)
                                    Text(
                                        '${_checkRoutingData.provider.name} hat sich bereits für ${_checkRoutingData.endAddress.city} registriert und führt voraussichtlich Transferservice vom und zum Bahnhof durch.'),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  AutoSizeText(
                                    'Bitte wähle die Leistung an, die du anbieten möchtest.',
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                  if (_checkRoutingData.endAddressAvailable)
                                    ProviderSelectionWidget(
                                      title:
                                          'Transferservice durch ${_checkRoutingData.provider.name}',
                                      text:
                                          'Transfers werden zwischen deiner Address und dem Bahnhof von ${_checkRoutingData.provider.name} durchgeführt.',
                                      caption: '',
                                      providerSelection:
                                          ProviderType.taxiShuttle,
                                      selectionFunction:
                                          providerSelectionFunction,
                                      active: ProviderType.taxiShuttle ==
                                          _providerUser.providerType,
                                    ),
                                  if (!_checkRoutingData.endAddressAvailable)
                                    ProviderSelectionWidget(
                                      title: 'Taxi- oder Mietwagenservice',
                                      text:
                                          'vom Bahnhof zu den Adressen der Postleitzahl ${_checkRoutingData.endAddress.postcode}. Gewerbeberechtigung notwendig.',
                                      providerSelection: ProviderType.taxi,
                                      selectionFunction:
                                          providerSelectionFunction,
                                      active: ProviderType.taxi ==
                                          _providerUser.providerType,
                                    ),
                                  ProviderSelectionWidget(
                                    title: 'Eigenes Tranferservice',
                                    text:
                                        'Du führst selbst den Transfer zwischen Bahnhof und deiner Adresse durch.',
                                    providerSelection: ProviderType.ownShuttle,
                                    selectionFunction:
                                        providerSelectionFunction,
                                    active: ProviderType.ownShuttle ==
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
                                            // _getStationName(_checkRoutingData
                                            //   .provider.stations);
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
                                      AutoSizeText(
                                        'Bitte teile uns deinen Unternehmensnamen mit.',
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
                                                        4
                                                    ? 'Bitte gib hier deinen Betriebsnamen ein'
                                                    : null,
                                                controller:
                                                    _providerNameFormFieldController,
                                                onChanged: (val) {
                                                  setState(() {
                                                    _providerUser.name = val;
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
                                                      timeInputFunction:
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
                                                      timeInputFunction:
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
                                            onPressed: (_providerUser.name !=
                                                    _defaultProviderUser.name)
                                                ? () async {
                                                    try {
                                                      _providerNameFormFieldController
                                                              .text =
                                                          _providerUser.name;
                                                      _pageSteps = 4;
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
                                          )
                                        ],
                                      )
                                    ])
                              ])),
                        ],
                      ))),
            // Fourth Page ------------------------------- 4 ----------------------------------
            if (_pageSteps >= 3 &&
                _providerUser.providerType == ProviderType.taxi)
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
                                      'Für welchen Bahnhof bietest du deine Transferservice an?',
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AddressInputScreen(
                                                      addressInputFunction:
                                                          stationSelectionFunction,
                                                      isEndAddress: false,
                                                      isStartAddress: false,
                                                      restrictions: 'Bahnhof',
                                                      title: 'Bahnhof suchen',
                                                    )));
                                      },
                                      child: AbsorbPointer(
                                        child: TextFormField(
                                            validator: (val) => !val
                                                    .contains('Bahnhof')
                                                ? 'Bitte gib hier einen Bahnhof ein'
                                                : null,
                                            controller:
                                                _stationFormFieldController,
                                            onChanged: (val) {
                                              setState(() {});
                                            },
                                            decoration: InputDecoration(
                                              hintText: 'Bahnhof hinzufügen',
                                              prefixIcon: Icon(Icons.train,
                                                  color: Theme.of(context)
                                                      .accentColor),
                                            )),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    AutoSizeText(
                                      'Du bietest deine Transferdienstleistungen für folgende Ortschaften an:',
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
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
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Container(
                                          child: FlatButton(
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            AddressInputScreen(
                                                              addressInputFunction:
                                                                  citySelectionFunction,
                                                              isEndAddress:
                                                                  false,
                                                              isStartAddress:
                                                                  false,
                                                              cityOnly: true,
                                                              title:
                                                                  'Ortschaft hinzufügen',
                                                            )));
                                              },
                                              child: Text(
                                                  'Weitere Ortschaften Hinzufügen')),
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
                                          onPressed:
                                              _providerUser.stations.length > 0
                                                  ? () {
                                                      ProviderService()
                                                          .updateProviderUserData(
                                                              uid: auth.uid,
                                                              data:
                                                                  _providerUser);
                                                    }
                                                  : null,
                                          child: Text('Jetzt registrieren'),
                                        )
                                      ],
                                    )
                                  ])
                            ]))
                      ]))),
            // Fourth Page ------------------------------- 4 ----------------------------------
            if (_pageSteps >= 3 &&
                    _providerUser.providerType == ProviderType.ownShuttle ||
                _providerUser.providerType == ProviderType.taxiShuttle)
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
                                'Wer kann Transferservices in Anspruch nehmen?',
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
                                buttonText: 'E-Mails hinzufügen',
                                providerPlanSelection: ProviderPlan.emailOnly,
                                selectionFunction:
                                    providerPlanSelectionFunction,
                                active: ProviderPlan.emailOnly ==
                                    _providerUser.providerPlan,
                              ),
                              ProviderSelectionWidget(
                                title: 'Alle',
                                text:
                                    'Alle Personen, die den Service zwischen Bahnhof und der Address ${_providerUser.addresses[0]} beautragen.',
                                providerPlanSelection: ProviderPlan.all,
                                selectionFunction:
                                    providerPlanSelectionFunction,
                                active: ProviderPlan.all ==
                                    _providerUser.providerPlan,
                              ),
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
                  emailListScreenFunction: emailListScreenFunction,
                  targetGroup: _providerUser.targetGroup,
                )));
  }

  void emailListScreenFunction(List<String> list) {
    setState(() {
      _providerUser.targetGroup = list;
    });
  }

  void providerPlanSelectionFunction(ProviderPlan selection) {
    setState(() {
      _providerUser.providerPlan = selection;
    });
  }

  void providerSelectionFunction(ProviderType selection) {
    setState(() {
      _providerUser.providerType = selection;
      _pageSteps = 3;
    });
  }

  void addressSelectionFunction(
      String input, String id, bool startAddress, bool endAddress) {
    setState(() {
      _addressFound = true;
      _request.endAddress = input;
      _request.endId = id;
    });
  }

  void stationSelectionFunction(
      String input, String id, bool startAddress, bool endAddress) {
    _stationFormFieldController.text = input;
    _setStationFromAddressFunction(station: _stationFormFieldController.text);
  }

  void citySelectionFunction(
      String input, String id, bool startAddress, bool endAddress) {
    _addCityToStations(input);
    // _stationFormFieldController.text = input;
    // _setStationFunction(station: _stationFormFieldController.text);
  }

  Future<void> _checkAddressStatus(String uid) async {
    try {
      final myStream = RoutingService().streamCheck(uid);
      _subscription = myStream.listen((data) {
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
          _subscription.cancel();
        }
      });
    } catch (e) {
      print(e);
    }
  }

  void _setStationFromAddressFunction({
    String address = '',
    // String postcode = '',
    String station = '',
    bool remove = false,
  }) {
    String scope = _providerUser.addresses[0];
    // If Taxi the scope is the postcode
    // If not Taxi the scope is the full address
    if (_providerUser.providerType == ProviderType.taxi)
      scope = getPartOfAddress(_providerUser.addresses[0], '__');
    setState(() {
      if (station != '')
        _providerUser.stations = [
          scope + '___' + station,
        ];
    });
  }

  void _addCityToStations(String city) {
    bool cityExists = false;
    _providerUser.stations.map((e) {
      String cityFromAddress = getPartOfAddress(e, '__');
      if (city == cityFromAddress) {
        cityExists = true;
      }
    }).toList();
    if (cityExists == false) {
      setState(() {
        _providerUser.stations
            .add(city + '___' + _stationFormFieldController.text);
      });
    }
  }

  void _removeCityFromStation(String city) {
    setState(() {
      int removeIndex;
      for (var i = 0; i < _providerUser.stations.length; i++) {
        String cityFromAddress =
            getPartOfAddress(_providerUser.stations[i], '__');
        if (city == cityFromAddress) {
          removeIndex = i;
        }
      }
      _providerUser.stations.removeAt(removeIndex);
    });
  }

  void _fromDateTimeToInt(Timespan timespan, DateTime time) {
    setState(() {
      if (timespan == Timespan.start) {
        setState(() {
          // _timeStartDateTime = time;
          _providerUser.timeStart = int.parse(format.format(time));
        });
      } else if (timespan == Timespan.end) {
        setState(() {
          // _timeEndDateTime = time;
          _providerUser.timeEnd = int.parse(format.format(time));
        });
      }
    });
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

  Widget _getCitiesFromStationsWidget(List<String> addresses) {
    if (addresses != null && addresses.length > 0) {
      return Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.spaceBetween,
          spacing: 8.0,
          children: addresses.map((address) {
            String city = getPartOfAddress(address, '__');
            return Chip(
              label: Text(city),
              onDeleted:
                  city == getPartOfAddress(_providerUser.addresses[0], '__')
                      ? null
                      : () => _removeCityFromStation(city),
            );
          }).toList());
    } else {
      return Wrap();
    }
  }
}
