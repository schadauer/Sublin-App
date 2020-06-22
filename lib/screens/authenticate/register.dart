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
  String type = 'private';
  String companyName = '';
  String dropdownValue = 'Taxi- oder Mietwagenunternehmen';
  final _formKey = GlobalKey<FormState>();
  TextEditingController _textFormFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getCurrentCoordinates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Registrierung'),
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                        onChanged: (val) {
                          setState(() {
                            email = val;
                          });
                        },
                        decoration: InputDecoration(
                            hintText: 'Email',
                            filled:
                                Theme.of(context).inputDecorationTheme.filled,
                            border:
                                Theme.of(context).inputDecorationTheme.border,
                            focusedBorder: Theme.of(context)
                                .inputDecorationTheme
                                .focusedBorder,
                            fillColor: Theme.of(context)
                                .inputDecorationTheme
                                .fillColor,
                            prefixIcon: Icon(Icons.email),
                            suffixIcon: IconButton(
                                icon: Icon(Icons.highlight_off),
                                onPressed: () {
                                  _textFormFieldController.text = '';
                                }))),
                    SizedBox(
                      height: 20,
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
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Flexible(
                          flex: 1,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                type = 'private';
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(12),
                              margin: EdgeInsets.only(right: 10),
                              color: Color.fromRGBO(245, 245, 245, 1),
                              child: Row(
                                children: <Widget>[
                                  (type == 'private')
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
                                type = 'business';
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(12),
                              margin: EdgeInsets.only(left: 10),
                              color: Color.fromRGBO(245, 245, 245, 1),
                              child: Row(
                                children: <Widget>[
                                  (type == 'business')
                                      ? _checked(context)
                                      : _unchecked(context),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text('Gewerblich',
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).accentColor)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    if (type == 'business')
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          TextFormField(
                              validator: (val) => val.length < 6
                                  ? 'Bitte gib einen gültigen Firmennamen ein'
                                  : null,
                              onChanged: (val) {
                                setState(() {
                                  companyName = val;
                                });
                              },
                              decoration: InputDecoration(
                                hintText: 'Dein Firmenname',
                                prefixIcon: Icon(Icons.business),
                              )),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            color: Color.fromRGBO(230, 230, 230, 1),
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 0),
                            child: DropdownButton<String>(
                              value: dropdownValue,
                              icon: Icon(Icons.arrow_downward),
                              iconSize: 24,
                              elevation: 16,
                              onChanged: (String newValue) {
                                setState(() {
                                  dropdownValue = newValue;
                                });
                              },
                              items: <String>[
                                'Taxi- oder Mietwagenunternehmen',
                                'Regionales Mobilitätsprojekt',
                                'Unternehmen für Mitarbeiter',
                                'Tourismusbetrieb für Gäste'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                              controller: _textFormFieldController,
                              validator: (val) => val.length < 6
                                  ? 'Bitte gib einen gültigen Firmennamen ein'
                                  : null,
                              onChanged: (val) {
                                setState(() {
                                  companyName = val;
                                });
                              },
                              decoration: InputDecoration(
                                  hintText: 'Dein Firmenstandort',
                                  prefixIcon: Icon(Icons.map),
                                  suffixIcon: IconButton(
                                      icon: Icon(Icons.highlight_off),
                                      onPressed: () {
                                        _textFormFieldController.text = '';
                                      }))),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        RaisedButton(
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              print(email);
                              print(password);
                              print(firstName);
                              _auth.register(email, password, firstName);
                            }

                            // FirebaseUser user = await _auth.signIn(email, password);

                            //print(user);
                          },
                          child: Text('Registrieren'),
                        ),
                        FlatButton(
                            textColor: Theme.of(context).accentColor,
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignIn())),
                            child: Text('Die bist schon registriert?')),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
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
}
