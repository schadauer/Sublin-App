import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sublin/models/auth.dart';
import 'package:sublin/models/provider_user.dart';
import 'package:sublin/models/time.dart';
import 'package:sublin/screens/address_input_screen.dart';
import 'package:sublin/services/auth_service.dart';
import 'package:sublin/services/provider_service.dart';
import 'package:sublin/widgets/drawer_side_navigation_widget.dart';
import 'package:sublin/widgets/header_widget.dart';

import 'package:sublin/widgets/provider_bottom_navigation_bar_widget.dart';
import 'package:sublin/widgets/input/time_field_widget.dart';

class ProviderHomeScreen extends StatefulWidget {
  static const routeName = '/providerHomeScreen';
  @override
  _ProviderHomeScreenState createState() => _ProviderHomeScreenState();
}

class _ProviderHomeScreenState extends State<ProviderHomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final AuthService authService = AuthService();
  ProviderService providerService = ProviderService();
  final _formKey = GlobalKey<FormState>();
  TextEditingController _stationFormFieldController = TextEditingController();
  TextEditingController _postcodeFormFieldController = TextEditingController();
  DateTime _timeEnd;
  DateTime _timeStart;
  String _providerName = '';
  String _station = '';
  List<String> _postcodes = [];
  List<String> _stations = [];

  @override
  void initState() {
    // _timeEnd = TimeOfDay(hour: 15, minute: 0)
    // _timeEnd = TimeOfDay.now();
    // _timeStart = TimeOfDay.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    // final user = Provider.of<User>(context);
    final providerUser = Provider.of<ProviderUser>(context);

    print(_providerName);

    // print(auth.uid);

    return Scaffold(
        bottomNavigationBar: providerUser.isProvider
            ? ProviderBottomNavigationBarWidget()
            : null,
        endDrawer: DrawerSideNavigationWidget(authService: authService),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverPersistentHeader(delegate: HeaderWidget(name: _providerName)),
            SliverList(
                delegate: SliverChildListDelegate([
              Container(
                height: 800,
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            if (providerUser.providerName == '')
                              TextFormField(
                                  validator: (val) => val.length < 4
                                      ? 'Bitte gib hier deinen Firmennamen ein'
                                      : null,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Flexible(flex: 1, child: Text('Von')),
                                  Flexible(
                                      flex: 2,
                                      child: TimeFildWidget(
                                        timespan: Timespan.start,
                                        timeInputFunction: _timeInputFunction,
                                      )),
                                  Flexible(flex: 1, child: Text('Bis')),
                                  Flexible(
                                      flex: 2,
                                      child: TimeFildWidget(
                                        timespan: Timespan.end,
                                        timeInputFunction: _timeInputFunction,
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
                                            builder: (context) =>
                                                AddressInputScreen(
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
                                        validator: (val) => !val
                                                .contains('Bahnhof')
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
                                              color: Theme.of(context)
                                                  .accentColor),
                                        )),
                                  ),
                                ),
                              ],
                            ),
                            if (_station != '')
                              Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Expanded(child: Divider()),
                                      Text(
                                        'Zubringerservice für',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6,
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
                                            controller:
                                                _postcodeFormFieldController,
                                            onChanged: (val) {
                                              _postcodeFormFieldController
                                                  .text = val;
                                            },
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
                                          if (_formKey.currentState
                                              .validate()) {
                                            ProviderService()
                                                .updateProviderUserData(
                                                    uid: auth.uid,
                                                    data: ProviderUser(
                                                      providerName:
                                                          _providerName,
                                                      stations: _stations,
                                                      postcodes: _postcodes,
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
            ]))
          ],
        ));
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

  void _timeInputFunction(Timespan timespan, time) {
    setState(() {
      if (timespan == Timespan.start) {
        setState(() {
          _timeStart = time;
        });
      } else if (timespan == Timespan.end) {
        setState(() {
          _timeEnd = time;
        });
      }
    });
  }

  void _openEndDrawer() {
    _scaffoldKey.currentState.openEndDrawer();
  }
}
