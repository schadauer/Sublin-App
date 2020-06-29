import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sublin/widgets/loading_widget.dart';
import 'package:sublin/services/auth_service.dart';

class SignIn extends StatefulWidget {
  static const routeName = '/signIn';
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool isLoading = false;
  bool textFocus = false;
  final AuthService _auth = AuthService();
  String email = '';
  String password = '';
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    if (isLoading == true) {
      return Loading();
    } else {
      return Scaffold(
          body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 40,
          ),
          Container(
            padding: EdgeInsets.all(15),
            width: MediaQuery.of(context).size.width,
            height: 80,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  'Willkommen zurück',
                  style: Theme.of(context).textTheme.headline1,
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
          GestureDetector(
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
                            hintText: 'Deine E-Mail',
                            prefixIcon: Icon(Icons.email),
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                          onChanged: (val) {
                            setState(() {
                              password = val;
                            });
                          },
                          obscureText: true,
                          // keyboardType: TextInputType.datetime,
                          //obscureText: true,
                          decoration: InputDecoration(
                              hintText: 'Passwort',
                              prefixIcon: Icon(Icons.lock))),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          SizedBox(
                            height: 10,
                          ),
                          RaisedButton(
                            onPressed: () async {
                              setState(() {
                                //isLoading = true;
                              });
                              FirebaseUser user =
                                  await _auth.signIn(email, password);
                              setState(() {
                                //isLoading = false;
                              });
                            },
                            child: Text('Einloggen'),
                          ),
                          FlatButton(
                              textColor: Theme.of(context).accentColor,
                              onPressed: () => Navigator.pop(context),
                              child: Text('Du bist noch nicht registriert?')),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ));
    }
  }
}
