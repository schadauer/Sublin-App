import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sublin/services/auth.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  String email = '';
  String password = '';
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Registrierung'),
          actions: <Widget>[
            FlatButton.icon(
              onPressed: (null),
              icon: Icon(Icons.person),
              label: Text(''),
            )
          ],
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                        hintText: 'Vorname',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        labelText: 'Vorname',
                        prefixIcon: Icon(Icons.person)),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                      validator: (val) => !EmailValidator.validate(val)
                          ? 'Bitte gib eine gültige E-Mailadresse an'
                          : null,
                      onChanged: (val) {
                        print(EmailValidator.validate(val));
                        setState(() {
                          email = val;
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        hintText: 'E-Mail',
                        labelText: 'E-Mail',
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
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                          hintText: 'Passwort',
                          labelText: 'Passwort',
                          prefixIcon: Icon(Icons.lock))),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FlatButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Die bist schon registriert?')),
                      RaisedButton(
                        color: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            print(email);
                            print(password);
                            _auth.register(email, password);
                          }

                          // FirebaseUser user = await _auth.signIn(email, password);

                          //print(user);
                        },
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: Text('Registrieren'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
