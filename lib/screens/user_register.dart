import 'package:Sublin/models/user_type.dart';
import 'package:Sublin/widgets/provider_selection_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:Sublin/screens/sign_in.dart';
import 'package:Sublin/services/auth_service.dart';
import 'package:Sublin/utils/is_email_format.dart';
import 'package:Sublin/utils/is_geolocation_permission_granted.dart';

class UserRegister extends StatefulWidget {
  @override
  _UserRegisterState createState() => _UserRegisterState();
}

class _UserRegisterState extends State<UserRegister> {
  final AuthService _auth = AuthService();
  String firstName = '';
  String email = '';
  String password = '';
  UserType userType = UserType.user;
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Hallo $firstName ',
                            style: Theme.of(context).textTheme.headline1,
                            textAlign: TextAlign.left,
                          ),
                          // if (firstNameProvided)
                          //   Icon(
                          //     emailProvided
                          //         ? Icons.sentiment_very_satisfied
                          //         : Icons.sentiment_satisfied,
                          //     size: 30,
                          //   ),
                          FlatButton(
                              textColor: Theme.of(context).secondaryHeaderColor,
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignIn())),
                              child: Text(
                                'Bereits registriert?',
                                style: Theme.of(context).textTheme.button,
                              )),
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
                                    ? 'Bitte gib deinen Vornamen an'
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
                                validator: (val) => val.length < 2
                                    ? 'Bitte gib eine gültige E-Mailadresse an'
                                    : null,
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
                                  hintText: 'Deine Email Adresse',
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
                                validator: (val) => val.length < 6
                                    ? 'Das Passwort muss eine Mindeslänge von 6 Zeichen haben'
                                    : null,
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
                            ProviderSelectionWidget(
                              title: 'Fahrgast',
                              text:
                                  'Du möchtest bequem ohne eigenes Auto überall hin mit öffentlichen Verkehr und Sublin für die "letzte Meile".',
                              selectionFunction: typeSelectionFunction,
                              userType: UserType.user,
                              active: userType == UserType.user,
                            ),
                            ProviderSelectionWidget(
                              title: 'Anbieter',
                              text:
                                  'Du bietest Transferdienste an, zu einer bestimmten Adresse oder innerhalb eines bestimmten Gebiets mit einer entsprechenden Lizenz.',
                              selectionFunction: typeSelectionFunction,
                              userType: UserType.provider,
                              active: userType == UserType.provider,
                            ),
                            ProviderSelectionWidget(
                              title: 'Sponsor',
                              text:
                                  'Du führst selbst keine Personentransfers durch und beauftragst einen lizenzierten Fahrtendienst für eine bestimmte Adresse oder ein Gebiet. Dieser führt für dich kostenlose Transferservices für den Fahrgast an.',
                              selectionFunction: typeSelectionFunction,
                              userType: UserType.sponsor,
                              active: userType == UserType.sponsor,
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
                                          userType: userType,
                                        );
                                      }
                                    } catch (e) {
                                      print(e);
                                    }
                                  },
                                  child: Text('Jetzt registrieren'),
                                ),
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

  void typeSelectionFunction(userTypeParam) {
    setState(() {
      userType = userTypeParam;
    });
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
      ('_getCurrentCoordinates: $e');
    }
  }
}
