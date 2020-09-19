import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:Sublin/widgets/progress_indicator_widget.dart';
import 'package:Sublin/theme/theme.dart';
import 'package:Sublin/models/user_type_enum.dart';
import 'package:Sublin/widgets/provider_selection_widget.dart';
import 'package:Sublin/screens/user_sign_in_screen.dart';
import 'package:Sublin/services/auth_service.dart';
import 'package:Sublin/utils/is_email_format.dart';

class UserRegisterScreen extends StatefulWidget {
  @override
  _UserRegisterScreenState createState() => _UserRegisterScreenState();
}

class _UserRegisterScreenState extends State<UserRegisterScreen> {
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
  PageController _pageViewController = PageController(initialPage: 0);
  // To controll which pages can be accessed
  int _pageStep = 0;
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwortTextController = TextEditingController();
  TextEditingController _firstNameTextController = TextEditingController();
  bool _emailAlreadyInUse = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pageViewController ?? _pageViewController.dispose();
    _emailTextController ?? _emailTextController.dispose();
    _passwortTextController ?? _passwortTextController.dispose();
    _firstNameTextController ?? _firstNameTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: PageView(
        controller: _pageViewController,
        children: [
          if (_pageStep >= 0)
            GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  FocusScope.of(context).unfocus();
                  setState(() {
                    textFocus = false;
                  });
                },
                child: Stack(
                  children: <Widget>[
                    ProgressIndicatorWidget(
                      index: 1,
                      elements: 2,
                      showProgressIndicator: false,
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 50, left: 15, right: 15),
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
                            ],
                          ),
                          SizedBox(
                            height: 20,
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
                      margin: EdgeInsets.only(top: (textFocus) ? 90 : 260),
                      duration: Duration(milliseconds: 100),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
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
                                    controller: _firstNameTextController,
                                    onChanged: (val) {
                                      setState(() {
                                        _pageStep = 0;
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
                                        prefixIcon: Icon(
                                          Icons.person,
                                        ))),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                    validator: (val) => val.length < 2 ||
                                            !isEmailFormat(val)
                                        ? 'Bitte gib eine gültige E-Mailadresse an'
                                        : _emailAlreadyInUse
                                            ? 'Email existiert bereits'
                                            : null,
                                    onTap: () {
                                      setState(() {
                                        textFocus = true;
                                      });
                                    },
                                    controller: _emailTextController,
                                    onChanged: (val) {
                                      setState(() {
                                        _pageStep = 0;
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
                                    controller: _passwortTextController,
                                    onChanged: (val) {
                                      setState(() {
                                        _pageStep = 0;
                                        password = val;
                                      });
                                    },
                                    obscureText: true,
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
                                      ),
                                    )),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    FlatButton(
                                        textColor: Theme.of(context)
                                            .secondaryHeaderColor,
                                        onPressed: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    UserSignInScreen())),
                                        child: Text(
                                          'Bereits registriert?',
                                          style: Theme.of(context)
                                              .textTheme
                                              .button,
                                        )),
                                    RaisedButton(
                                      onPressed: () async {
                                        try {
                                          if (_formKey.currentState
                                              .validate()) {
                                            FocusScope.of(context).unfocus();
                                            // dynamic register = await AuthService()
                                            //     .registerWithEmailAndPassword(
                                            //         email: _emailTextController
                                            //             .text,
                                            //         password:
                                            //             _passwortTextController
                                            //                 .text);

                                            setState(() {
                                              _pageStep = 1;
                                            });
                                            _pageViewController.nextPage(
                                                duration:
                                                    Duration(milliseconds: 300),
                                                curve: Curves.easeOut);

                                            // if (register is UserCredential) {
                                            // } else if (register ==
                                            //     SublinError.emailAlreadyInUse) {
                                            //   setState(() {
                                            //     _emailAlreadyInUse = true;
                                            //   });
                                            //   print(
                                            //       'Email ist bereits vorhanden');
                                            // } else {
                                            //   print('something Went wrong');
                                            // }
                                          }
                                        } catch (e) {
                                          print(e);
                                        }
                                      },
                                      child: Text('Weiter'),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
          // Second Page ------------------------------- 2 ----------------------------------
          if (_pageStep >= 1)
            SingleChildScrollView(
                child: Column(
              children: [
                ProgressIndicatorWidget(
                  index: 2,
                  elements: 2,
                  showProgressIndicator: false,
                ),
                Padding(
                  padding: ThemeConstants.mediumPadding,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              '$firstName, du meldest dich an als: ',
                              style: Theme.of(context).textTheme.headline1,
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
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
                            'Du bietest Transferdienste an, entweder zu einer bestimmten Adresse oder innerhalb eines bestimmten Gebiets.',
                        selectionFunction: typeSelectionFunction,
                        userType: UserType.provider,
                        active: userType == UserType.provider,
                      ),
                      ProviderSelectionWidget(
                        title: 'Sponsor',
                        text:
                            'Du führst selbst keine Personentransfers durch und beauftragst einen Fahrtendienst.',
                        selectionFunction: typeSelectionFunction,
                        userType: UserType.sponsor,
                        active: userType == UserType.sponsor,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          RaisedButton(
                            onPressed: () async {
                              try {
                                await _auth.register(
                                  email: email,
                                  password: password,
                                  firstName: firstName,
                                  userType: userType,
                                );
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
              ],
            ))
        ],
      ),
    ));
  }

  void typeSelectionFunction(userTypeParam) {
    setState(() {
      userType = userTypeParam;
    });
  }

  // Icon _checked(context) {
  //   return Icon(
  //     Icons.check_box,
  //     // color: Theme.of(context).accentColor,
  //   );
  // }

  // Icon _unchecked(context) {
  //   return Icon(
  //     Icons.check_box_outline_blank,
  //     color: Theme.of(context).accentColor,
  //   );
  // }

  // Future<void> _getCurrentCoordinates() async {
  //   final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  //   try {
  //     // print(await isLocationPermissionGranted());
  //     await geolocator.getCurrentPosition(
  //         desiredAccuracy: LocationAccuracy.bestForNavigation);
  //   } catch (e) {
  //     ('_getCurrentCoordinates: $e');
  //   }
  // }
}
