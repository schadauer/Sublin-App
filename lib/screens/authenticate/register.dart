import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sublin/services/auth_service.dart';

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
  String dropdownValue = 'Taxigewerbe';
  final _formKey = GlobalKey<FormState>();
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
                    // TextFormField(
                    //   onChanged: (val) {
                    //     setState(() {
                    //       firstName = val;
                    //     });
                    //   },
                    //   decoration: InputDecoration(
                    //       hintText: 'Vorname',
                    //       fillColor: Colors.black12,
                    //       filled: true,
                    //       border: InputBorder.none,
                    //       focusedBorder: OutlineInputBorder(
                    //           borderRadius: BorderRadius.circular(5.0)),
                    //       prefixIcon: Icon(Icons.person)),
                    // ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                        // validator: (val) => !EmailValidator.validate(val)
                        //     ? 'Bitte gib eine gültige E-Mailadresse an'
                        //     : null,
                        onChanged: (val) {
                          setState(() {
                            email = val;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'E-Mail',
                          prefixIcon: Icon(Icons.email),
                        )),
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
                              color: Colors.black12,
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
                                    style: TextStyle(
                                      color: Theme.of(context).accentColor,
                                    ),
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
                              color: Colors.black12,
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
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: 'Dein Firmenname',
                                prefixIcon: Icon(Icons.business),
                              )),
                        ],
                      ),
                    SizedBox(
                      height: 20,
                    ),
                    DropdownButton<String>(
                      value: dropdownValue,
                      icon: Icon(Icons.arrow_downward),
                      iconSize: 24,
                      elevation: 16,
                      // style: TextStyle(color: Colors.deepPurple),
                      // underline: Container(
                      //   height: 2,
                      //   color: Colors.deepPurpleAccent,
                      // ),
                      onChanged: (String newValue) {
                        setState(() {
                          dropdownValue = newValue;
                        });
                      },
                      items: <String>['Taxigewerbe', 'Two', 'Free', 'Four']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
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
                            onPressed: () => Navigator.pop(context),
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
}
