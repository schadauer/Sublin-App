import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:sublin/screens/authenticate/sign_in.dart';
import 'package:sublin/services/auth_service.dart';
import 'package:sublin/utils/is_geolocation_permission_granted.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  String firstName = '';
  String email = '';
  String password = '';
  String type = 'user';
  String providerName = '';
  // String providerAddress = '';
  // String providerType = 'Taxi- oder Mietwagenunternehmen';
  final _formKey = GlobalKey<FormState>();
  TextEditingController _providerAddressFieldController =
      TextEditingController();
  TextEditingController _emailFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getCurrentCoordinates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: Text('Registrierung'),
        // ),
        body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => FocusScope.of(context).unfocus(),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.all(15),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.38,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        'Hallo',
                        style: Theme.of(context).textTheme.headline1,
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Wir sind in der Testphase. Bitte hilf uns, dieses Service auch in deinen Regionen verfügbar zu machen. Melde dich an und gib deine Plätze bekannt, die du ohne eigenes Auto erreichen willst. Damit können wir gezielter dort beginnen, wo die Nachfrage am größten ist.',
                        style: Theme.of(context).textTheme.bodyText1,
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                              onChanged: (val) {
                                setState(() {
                                  email = val;
                                });
                              },
                              decoration: InputDecoration(
                                hintText: 'Email',
                                filled: Theme.of(context)
                                    .inputDecorationTheme
                                    .filled,
                                border: Theme.of(context)
                                    .inputDecorationTheme
                                    .border,
                                focusedBorder: Theme.of(context)
                                    .inputDecorationTheme
                                    .focusedBorder,
                                fillColor: Theme.of(context)
                                    .inputDecorationTheme
                                    .fillColor,
                                prefixIcon: Icon(Icons.email),
                              )),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                              validator: (val) => val.length < 6
                                  ? 'Dein Passwort muss mind. 5 Zeichen lang sein'
                                  : null,
                              onChanged: (val) {
                                setState(() {
                                  password = val;
                                });
                              },
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: 'Passwort',
                                prefixIcon: Icon(Icons.lock),
                              )),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Flexible(
                                flex: 1,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      type = 'user';
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(12),
                                    margin: EdgeInsets.only(right: 10),
                                    color: Color.fromRGBO(245, 245, 245, 1),
                                    child: Row(
                                      children: <Widget>[
                                        (type == 'user')
                                            ? _checked(context)
                                            : _unchecked(context),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          'Privat',
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      type = 'provider';
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(12),
                                    margin: EdgeInsets.only(left: 10),
                                    color: Color.fromRGBO(245, 245, 245, 1),
                                    child: Row(
                                      children: <Widget>[
                                        (type == 'provider')
                                            ? _checked(context)
                                            : _unchecked(context),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text('Gewerblich',
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .accentColor)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          if (type == 'provider')
                            TextFormField(
                                validator: (val) => val.length < 6
                                    ? 'Bitte gib einen gültigen Firmennamen ein'
                                    : null,
                                onChanged: (val) {
                                  setState(() {
                                    providerName = val;
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: 'Dein Firmenname',
                                  prefixIcon: Icon(Icons.business),
                                )),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              SizedBox(
                                height: 10,
                              ),
                              RaisedButton(
                                onPressed: () async {
                                  try {
                                    if (_formKey.currentState.validate()) {
                                      await _auth.register(
                                        email: email,
                                        password: password,
                                        firstName: firstName,
                                        type: type,
                                        providerName: providerName,
                                        // providerAddress: providerAddress,
                                        // providerType: providerType,
                                      );
                                    }
                                  } catch (e) {
                                    print(e);
                                  }
                                },
                                child: Text('Registrieren'),
                              ),
                              FlatButton(
                                  textColor: Theme.of(context).accentColor,
                                  onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SignIn())),
                                  child: Text('Du bist schon registriert?')),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )));
  }

  Icon _checked(context) {
    return Icon(
      Icons.radio_button_checked,
      color: Theme.of(context).accentColor,
    );
  }

  Icon _unchecked(context) {
    return Icon(
      Icons.radio_button_unchecked,
      color: Colors.black12,
    );
  }

  Future<void> _getCurrentCoordinates() async {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    try {
      print(await isLocationPermissionGranted());
      await geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);
    } catch (e) {
      print('_getCurrentCoordinates: $e');
    }
  }

  // void textInputFunction(
  //     String input, String id, bool startAddress, bool endAddress) {
  //   print(input);
  //   setState(() {
  //     providerAddress = input;
  //   });
  //   _providerAddressFieldController.text = input;
  // }

  // Future _pushNavigation(BuildContext context) {
  //   return Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //           builder: (context) => AddressInputScreen(
  //                 textInputFunction: textInputFunction,
  //                 isEndAddress: false,
  //                 isStartAddress: false,
  //               )));
  // }
}
