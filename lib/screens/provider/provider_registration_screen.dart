import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:sublin/models/auth.dart';
import 'package:sublin/models/provider_selection.dart';
import 'package:sublin/models/provider_user.dart';
import 'package:sublin/models/request.dart';
import 'package:sublin/models/routing.dart';
import 'package:sublin/models/timespan.dart';
import 'package:sublin/models/user.dart';
import 'package:sublin/screens/address_input_screen.dart';
import 'package:sublin/services/auth_service.dart';
import 'package:sublin/services/provider_user_service.dart';

import 'package:sublin/services/routing_service.dart';
import 'package:sublin/widgets/address_search_widget.dart';
import 'package:sublin/widgets/drawer_side_navigation_widget.dart';
import 'package:sublin/widgets/input/time_field_widget.dart';
import 'package:sublin/widgets/progress_indicator_widget.dart';
import 'package:sublin/widgets/provider/provider_selection_widget.dart';

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
  ProviderUser _providerUser = ProviderUser();
  ProviderUser _defaultProviderUser = ProviderUser();
  Routing _defaultValueRouting = Routing();
  Routing _checkRoutingData;
  Request _request = Request();
  bool _showProgressIndicator = false;
  String _checkId = 'Initial';
  // Button active or disabled
  bool _addressFound = false;
  StreamSubscription<Routing> _subscription;
  int _pageSteps = 1;
  // ProviderType _providerSelection;

  DateFormat format = DateFormat('HHmm');
  var time = DateTime.parse("1969-07-20 20:18:04Z");
  // DateTime _timeEndDateTime;
  // DateTime _timeStartDateTime;

  String _station = '';

  @override
  void initState() {
    super.initState();
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
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Auth auth = Provider.of<Auth>(context);
    final User user = Provider.of<User>(context);
    final providerUser = Provider.of<ProviderUser>(context);

    print(providerUser.providerType);

    return Scaffold(
      appBar: AppBar(
        title: Text('Registrierung als Anbieter'),
        elevation: 0.0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      drawer: DrawerSideNavigationWidget(
        authService: AuthService(),
      ),
      body: SafeArea(
        child: PageView(
          controller: _pageViewController,
          children: <Widget>[
            // First Page ------------------------------- 1 ----------------------------------
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
                                'Hallo ' + user.firstName + ',',
                                style: Theme.of(context).textTheme.headline3,
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          AutoSizeText(
                            'finde deine Betriebsadresse, um herauszufinden, ob sich für deine Postleitzahl bereits ein Taxi- oder Mietwagenunternehmen registriert hat.',
                            style: Theme.of(context).textTheme.bodyText1,
                            maxLines: 8,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          AddressSearchWidget(
                            addressInputFunction: addressInputFunction,
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
                                          });
                                          await RoutingService().requestRoute(
                                            uid: auth.uid,
                                            startAddress: _request.startAddress,
                                            startId: _request.startId,
                                            endAddress: _request.endAddress,
                                            endId: _request.endId,
                                            checkAddress: true,
                                            timestamp: DateTime.now()
                                                .millisecondsSinceEpoch,
                                          );
                                          // At the moment only one address is possible
                                          _providerUser.addresses[0] =
                                              _request.endAddress;
                                          _checkAddressStatus(auth.uid);
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
                                        'Für die Postleitzahl ${_checkRoutingData.endAddress.postcode} hat sich noch kein Taxi- oder Mietwagenunternehmen registriert.'),
                                  if (_checkRoutingData.endAddressAvailable)
                                    Text(
                                        '${_checkRoutingData.provider.name} hat sich bereits für die Postleitzahl ${_checkRoutingData.endAddress.postcode} registriert und führt voraussichtlich Zubringerservices vom Bahnhof zu den Adressen dieser Postleitzahl durch.'),
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
                                          'Zubringerservice durch ${_checkRoutingData.provider.name}',
                                      text:
                                          'Kostenloses Service vom Bahnhof zu deiner angegebenen Adresse für ausgewählte Personen',
                                      caption: '',
                                      providerSelection:
                                          ProviderType.taxiShuttle,
                                      providerSelectionFunction:
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
                                      providerSelectionFunction:
                                          providerSelectionFunction,
                                      active: ProviderType.taxi ==
                                          _providerUser.providerType,
                                    ),
                                  ProviderSelectionWidget(
                                    title: 'Eigenes Zubringerservice',
                                    text:
                                        'Kostenloses Service vom Bahnhof zu deiner angegebenen Adresse für ausgewählte Personen',
                                    providerSelection: ProviderType.ownShuttle,
                                    providerSelectionFunction:
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
                                            _getStationName(_checkRoutingData
                                                .provider.stations);
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
                                        _providerUser.name ==
                                                _defaultProviderUser.name
                                            ? 'Nur noch zwei Schritte'
                                            : '${_providerUser.name} hat noch gefehlt!',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline3,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      AutoSizeText(
                                        'Bitte teil uns deinen Betriebsnamen mit.',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Card(
                                        child: Column(children: <Widget>[
                                          Hero(
                                            tag: 'addressField',
                                            child: Material(
                                              child: TextFormField(
                                                  validator: (val) => val
                                                              .length <
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
                                                        'Dein Betriebsname',
                                                    prefixIcon: Icon(
                                                        Icons.account_circle,
                                                        color: Theme.of(context)
                                                            .accentColor),
                                                  )),
                                            ),
                                          ),
                                        ]),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      AutoSizeText(
                                        'Zu welchen Uhrzeiten bietest du deine Leistungen an?',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      GestureDetector(
                                        onTap: () => null, // _pickTime(),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Flexible(
                                                flex: 1, child: Text('Von')),
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
                                                flex: 1, child: Text('bis')),
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
            if (_pageSteps >= 3)
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
                                      'Für welchen Bahnhof bietest du deine Zubringerdienste an?',
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
                                                          _stationInputFunction,
                                                      isEndAddress: false,
                                                      isStartAddress: false,
                                                      restrictions: 'Bahn',
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
                                              setState(() {
                                                // _providerName = val;
                                              });
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
                                      'Für welche Postleitzahlen bietest du deine Dienste an?',
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    _getPostcodes(_providerUser.postcodes),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Container(
                                          width: 170,
                                          child: TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
                                              maxLength: 4,
                                              buildCounter:
                                                  (BuildContext context,
                                                          {int currentLength,
                                                          int maxLength,
                                                          bool isFocused}) =>
                                                      null,
                                              controller:
                                                  _postcodeFormFieldController,
                                              enabled: _providerUser.stations !=
                                                      _defaultProviderUser
                                                          .stations
                                                  ? false
                                                  : true,
                                              decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.all(10),
                                                  hintText: 'PLZ',
                                                  prefixIcon:
                                                      Icon(Icons.add_location),
                                                  suffixIcon: IconButton(
                                                    icon: Icon(Icons.add_box),
                                                    onPressed: () {
                                                      _postcodeInputFunction(
                                                          input:
                                                              _postcodeFormFieldController
                                                                  .text);
                                                      setState(() {
                                                        _postcodeFormFieldController
                                                            .text = '';
                                                      });
                                                    },
                                                  ))),
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
                                          onPressed: _providerUser.postcodes !=
                                                  _defaultProviderUser.postcodes
                                              ? () {
                                                  ProviderService()
                                                      .updateProviderUserData(
                                                          uid: auth.uid,
                                                          data: _providerUser);
                                                }
                                              : null,
                                          child: Text('Jetzt registrieren'),
                                        )
                                      ],
                                    )
                                  ])
                            ]))
                      ])))
          ],
        ),
      ),
    );
  }

  String _getStationName(List stations) {
    String station;
    stations.map((e) {
      print(e);
    });
    return station;
  }

  void providerSelectionFunction(selection) {
    setState(() {
      _providerUser.providerType = selection;
      // _providerSelection = selection;
      _pageSteps = 3;
      _providerUser.isTaxi = selection == ProviderType.taxi ? true : false;
    });
  }

  void addressInputFunction(
      String input, String id, bool startAddress, bool endAddress) {
    setState(() {
      _addressFound = true;
      _request.endAddress = input;
      _request.endId = id;
      _providerUser.addresses = [
        input,
        id,
      ];
    });
  }

  void _stationInputFunction(
      String input, String id, bool startAddress, bool endAddress) {
    setState(() {
      _stationFormFieldController.text = input;
      _station = input;
    });
  }

  void _postcodeInputFunction({String input, bool remove = false}) {
    if (input.length == 4) {
      var index = _providerUser.postcodes.indexOf(input);
      print(index);
      setState(() {
        if (remove) {
          if (index >= 0) {
            _providerUser.postcodes.removeAt(index);
            _providerUser.stations.removeAt(index);
          }
        } else {
          _providerUser.postcodes = [..._providerUser.postcodes, input];
          _providerUser.stations = [
            ..._providerUser.stations,
            input + '_' + _station
          ];
          print(_providerUser.stations);
        }
      });
    }
  }

  void _checkAddressStatus(uid) {
    final myStream = RoutingService().streamCheck(uid);
    _subscription = myStream.listen((data) {
      if (data.id != _defaultValueRouting.id && _checkId != data.id) {
        setState(() {
          _checkRoutingData = data;
          _checkId = data.id;
          _showProgressIndicator = false;
          _pageSteps = 2;
          _pageViewController.nextPage(
              duration: Duration(milliseconds: 300), curve: Curves.easeOut);
        });
      }
    });
  }

  void _fromDateTimeToInt(Timespan timespan, time) {
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

  Widget _getPostcodes(List<String> postcodes) {
    if (postcodes != null && postcodes.length > 0) {
      return Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.spaceBetween,
          spacing: 8.0,
          children: postcodes.map((postcode) {
            return Chip(
              label: Text(postcode),
              onDeleted: () =>
                  _postcodeInputFunction(input: postcode, remove: true),
            );
          }).toList());
    } else {
      return Wrap();
    }
  }
}
