import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sublin/models/auth.dart';
import 'package:sublin/models/provider_user.dart';
import 'package:sublin/models/time.dart';
import 'package:sublin/screens/address_input_screen.dart';
import 'package:sublin/services/auth_service.dart';
import 'package:sublin/services/provider_user_service.dart';
import 'package:sublin/utils/get_time_format.dart';
import 'package:sublin/widgets/drawer_side_navigation_widget.dart';
import 'package:sublin/widgets/provider_header_widget.dart';
import 'package:sublin/widgets/input/time_field_widget.dart';

class ProviderRegistration extends StatefulWidget {
  static const routeName = '/providerRegistration';
  @override
  _ProviderRegistrationState createState() => _ProviderRegistrationState();
}

class _ProviderRegistrationState extends State<ProviderRegistration> {
  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final AuthService authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  ProviderService providerService = ProviderService();
  TextEditingController _providerNameFormFieldController =
      TextEditingController();
  TextEditingController _stationFormFieldController = TextEditingController();
  TextEditingController _postcodeFormFieldController = TextEditingController();
  DateFormat format = DateFormat('HHmm');
  var time = DateTime.parse("1969-07-20 20:18:04Z");

  DateTime _timeEndDateTime;
  DateTime _timeStartDateTime;

  int _timeEnd;
  int _timeStart;
  String _providerName = '';
  String _station = '';
  List<String> _postcodes = [];
  List<String> _stations = [];

  bool showEditProfile = false;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    final providerUser = Provider.of<ProviderUser>(context);

    void editProfile() {
      setState(() {
        showEditProfile = !showEditProfile;
        _providerName = providerUser.providerName ?? '';
        _stations = providerUser.stations ?? [];
        _postcodes = providerUser.postcodes ?? [];
      });
      _providerNameFormFieldController.text = providerUser.providerName ?? '';
      _stationFormFieldController.text = providerUser.stations[0].substring(
              providerUser.stations[0].indexOf('_') + 1,
              providerUser.stations[0].length) ??
          '';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Sublin'),
        backgroundColor: Colors.black12,
      ),
      drawer: DrawerSideNavigationWidget(
        authService: AuthService(),
      ),
      body: Container(
        child: Container(
          height: 1000,
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(15),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Card(
                        child: Column(children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(child: Divider()),
                              Text(
                                'Betriebsname',
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              Expanded(child: Divider()),
                            ],
                          ),
                          TextFormField(
                              validator: (val) => val.length < 4
                                  ? 'Bitte gib hier deinen Firmennamen ein'
                                  : null,
                              controller: _providerNameFormFieldController,
                              onChanged: (val) {
                                setState(() {
                                  _providerName = val;
                                });
                              },
                              decoration: InputDecoration(
                                hintText: 'Dein Betriebsname',
                                prefixIcon: Icon(Icons.account_circle,
                                    color: Theme.of(context).accentColor),
                              )),
                        ]),
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(child: Divider()),
                          Text(
                            'Betriebszeiten',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          Expanded(child: Divider()),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => null, // _pickTime(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Flexible(flex: 1, child: Text('Von')),
                            // Flexible(
                            //     flex: 2,
                            //     child: CupertinoDatePicker(
                            //         onDateTimeChanged: (dataTime) {})),
                            Flexible(
                                flex: 2,
                                child: TimeFildWidget(
                                  initalTime: _fromIntToDateTime(
                                      providerUser.timeStart),
                                  timespan: Timespan.start,
                                  timeInputFunction: _fromDateTimeToInt,
                                )),
                            Flexible(flex: 1, child: Text('Bis')),
                            Flexible(
                                flex: 2,
                                child: TimeFildWidget(
                                  initalTime:
                                      _fromIntToDateTime(providerUser.timeEnd),
                                  timespan: Timespan.end,
                                  timeInputFunction: _fromDateTimeToInt,
                                ))
                          ],
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(child: Divider()),
                          Text(
                            'zum/vom Bahnhof',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          Expanded(child: Divider()),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddressInputScreen(
                                            textInputFunction:
                                                _stationInputFunction,
                                            isEndAddress: false,
                                            isStartAddress: false,
                                            restrictions: 'Bahn',
                                            title: 'Bahnhof suchen',
                                          )));
                            },
                            child: AbsorbPointer(
                              child: TextFormField(
                                  validator: (val) => !val.contains('Bahnhof')
                                      ? 'Bitte gib hier einen Bahnhof ein'
                                      : null,
                                  controller: _stationFormFieldController,
                                  onChanged: (val) {
                                    setState(() {
                                      _providerName = val;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Bahnhof hinzufügen',
                                    prefixIcon: Icon(Icons.train,
                                        color: Theme.of(context).accentColor),
                                  )),
                            ),
                          ),
                        ],
                      ),
                      if (_stations != [])
                        Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(child: Divider()),
                                Text(
                                  'zu und von folgenden Postleitzahlen',
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                                Expanded(child: Divider()),
                              ],
                            ),
                            _getPostcodes(_postcodes),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: <Widget>[
                                Container(
                                  width: 170,
                                  child: TextFormField(
                                      // validator: (val) => (val.length <
                                      //             3 &&
                                      //         val.length < 6)
                                      //     ? 'Bitte gib zumindest eine gültige PLZ ein'
                                      //     : null,
                                      keyboardType: TextInputType.number,
                                      maxLength: 4,
                                      buildCounter: (BuildContext context,
                                              {int currentLength,
                                              int maxLength,
                                              bool isFocused}) =>
                                          null,
                                      controller: _postcodeFormFieldController,
                                      onChanged: (val) {
                                        _postcodeFormFieldController.text = val;
                                      },
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(10),
                                          hintText: 'PLZ',
                                          prefixIcon: Icon(Icons.add_location),
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
                          ],
                        ),
                      Row(
                        children: <Widget>[
                          Expanded(child: Divider()),
                          Text(
                            'oder zu folgenden Adressen',
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          Expanded(child: Divider()),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(child: Divider()),
                          Text(
                            'Bedingungen',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          Expanded(child: Divider()),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Container(
                            child: InkWell(
                              onTap: () {
                                setState(() {});
                              },
                              child: Container(
                                padding: EdgeInsets.all(12),
                                color: Color.fromRGBO(245, 245, 245, 1),
                                child: Row(
                                  children: <Widget>[
                                    SizedBox(
                                      width: 13,
                                    ),
                                    Text(
                                      'Ich bin lizenzierter Anbieter',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              RaisedButton(
                                onPressed: () async {
                                  try {
                                    if (_formKey.currentState.validate()) {
                                      ProviderService().updateProviderUserData(
                                          uid: auth.uid,
                                          data: ProviderUser(
                                            providerName: _providerName,
                                            stations: _stations,
                                            postcodes: _postcodes,
                                            timeStart: _timeStart,
                                            timeEnd: _timeEnd,
                                          ));
                                    }
                                  } catch (e) {
                                    print(e);
                                  }
                                },
                                child: Text('Daten speichern'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    //     ],
    //   ),
    // );
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

  void _postcodeInputFunction({String input, bool remove = false}) {
    if (input.length == 4) {
      var index = _postcodes.indexOf(input);
      if (remove) {
        if (index >= 0) {
          _postcodes.removeAt(index);
          _stations.removeAt(index);
        }
      } else {
        if (index == -1) {
          _postcodes.add(input);
          _stations.add(input + '_' + _station);
        }
      }
      setState(() {
        _postcodes = _postcodes;
      });
    }
  }

  void _stationInputFunction(
      String input, String id, bool startAddress, bool endAddress) {
    setState(() {
      _stationFormFieldController.text = input;
      _station = input;
    });
  }

  void _fromDateTimeToInt(Timespan timespan, time) {
    setState(() {
      if (timespan == Timespan.start) {
        setState(() {
          _timeStartDateTime = time;
          _timeStart = int.parse(format.format(time));
        });
      } else if (timespan == Timespan.end) {
        setState(() {
          _timeEndDateTime = time;
          _timeEnd = int.parse(format.format(time));
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

  // void _openEndDrawer() {
  //   _scaffoldKey.currentState.openEndDrawer();
  // }
}
