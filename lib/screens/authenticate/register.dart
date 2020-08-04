import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:Sublin/screens/authenticate/sign_in.dart';
import 'package:Sublin/services/auth_service.dart';
import 'package:Sublin/utils/is_email_format.dart';
import 'package:Sublin/utils/is_geolocation_permission_granted.dart';

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
  bool textFocus = false;
  bool firstNameProvided = false;
  bool emailProvided = false;
  bool passwordProvided = false;
  bool providerChecked = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // _getCurrentCoordinates();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              FocusScope.of(context).unfocus();
              setState(() {
                textFocus = false;
              });
            },
            child: Stack(
              children: <Widget>[
                SizedBox(
                  height: 40,
                ),
                Container(
                  padding: EdgeInsets.only(top: 70, left: 15, right: 15),
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Hallo $firstName ',
                            style: Theme.of(context).textTheme.headline1,
                            textAlign: TextAlign.left,
                          ),
                          if (firstNameProvided)
                            Icon(
                              emailProvided
                                  ? Icons.sentiment_very_satisfied
                                  : Icons.sentiment_satisfied,
                              size: 30,
                            )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      AutoSizeText(
                        'Diese App soll dir in der Zukunft ermöglichen, bequem ohne eigenes Auto überall hinzukommen. Wir sind in der Testphase. Melde dich an und gib deine Plätze bekannt, die du ohne eigenes Auto erreichen willst. Damit können wir gezielter dort nach Anbietern suchen, wo du sie benötigst.',
                        style: Theme.of(context).textTheme.bodyText1,
                        maxLines: 8,
                      ),
                    ],
                  ),
                ),
                AnimatedContainer(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  margin: EdgeInsets.only(top: (textFocus) ? 120 : 300),
                  duration: Duration(milliseconds: 100),
                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            TextFormField(
                                validator: (val) => val.length < 2
                                    ? 'Bitte gib einen Vornamen ein'
                                    : null,
                                onTap: () {
                                  textFocus = true;
                                },
                                onChanged: (val) {
                                  setState(() {
                                    firstName = val;
                                    if (val.length > 0) {
                                      firstNameProvided = true;
                                    } else {
                                      firstNameProvided = false;
                                    }
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: 'Dein Vorname',
                                  prefixIcon: Icon(Icons.person,
                                      color: firstNameProvided
                                          ? Theme.of(context).accentColor
                                          : null),
                                )),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                                onTap: () {
                                  setState(() {
                                    textFocus = true;
                                  });
                                },
                                onChanged: (val) {
                                  setState(() {
                                    email = val;
                                    if (isEmailFormat(val)) {
                                      emailProvided = true;
                                    } else {
                                      emailProvided = false;
                                    }
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
                                  prefixIcon: Icon(
                                    Icons.email,
                                    color: emailProvided
                                        ? Theme.of(context).accentColor
                                        : null,
                                  ),
                                )),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                                onTap: () {
                                  setState(() {
                                    textFocus = true;
                                  });
                                },
                                onChanged: (val) {
                                  setState(() {
                                    password = val;
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: 'Passwort',
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
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: emailProvided
                                        ? Theme.of(context).accentColor
                                        : null,
                                  ),
                                )),
                            SizedBox(
                              height: 10,
                            ),
                            Card(
                              child: Container(
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      providerChecked = !providerChecked;
                                      if (providerChecked) {
                                        type = 'provider';
                                      } else {
                                        type = 'user';
                                      }
                                    });
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 15),
                                    // color: Color.fromRGBO(245, 245, 245, 1),
                                    child: Row(
                                      children: <Widget>[
                                        (type == 'provider')
                                            ? _checked(context)
                                            : _unchecked(context),
                                        SizedBox(
                                          width: 13,
                                        ),
                                        Text(
                                          'Ich biete Transferservice an',
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                RaisedButton(
                                  onPressed: () async {
                                    try {
                                      if (_formKey.currentState.validate()) {
                                        await _auth.register(
                                          email: email,
                                          password: password,
                                          firstName: firstName,
                                          type: type,
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
                ),
              ],
            )));
  }

  Icon _checked(context) {
    return Icon(
      Icons.check_box,
      // color: Theme.of(context).accentColor,
    );
  }

  Icon _unchecked(context) {
    return Icon(
      Icons.check_box_outline_blank,
      color: Theme.of(context).accentColor,
    );
  }

  Future<void> _getCurrentCoordinates() async {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    try {
      // print(await isLocationPermissionGranted());
      await geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);
    } catch (e) {
      print('_getCurrentCoordinates: $e');
    }
  }
}
