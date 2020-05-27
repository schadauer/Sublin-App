import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sublin/screens/authenticate/register.dart';
import 'package:sublin/screens/loading.dart';
import 'package:sublin/services/auth_service.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool isLoading = false;
  final AuthService _auth = AuthService();
  String email = '';
  String password = '';
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return isLoading == true
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text('Login'),
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
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Register())),
                              child: Text('Du bist noch nicht registriert?')),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ));
  }
}
