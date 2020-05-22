import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sublin/screens/authenticate/register.dart';
import 'package:sublin/screens/loading.dart';
import 'package:sublin/services/auth.dart';

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
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      TextFormField(
                          onChanged: (val) {
                            setState(() {
                              email = val;
                            });
                          },
                          decoration: InputDecoration(
                            fillColor: Colors.black12,
                            filled: true,
                            border: InputBorder.none,
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            hintText: 'Benutzername',
                            prefixIcon: Icon(Icons.email),
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                          onChanged: (val) {
                            setState(() {
                              password = val;
                            });
                          },
                          keyboardType: TextInputType.datetime,
                          //obscureText: true,
                          decoration: InputDecoration(
                              fillColor: Colors.black12,
                              filled: true,
                              border: InputBorder.none,
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                              hintText: 'Passwort',
                              prefixIcon: Icon(Icons.lock))),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          FlatButton(
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Register())),
                              child: Text('Du bist noch nicht registriert?')),
                          RaisedButton(
                            color: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            onPressed: () async {
                              setState(() {
                                //isLoading = true;
                              });
                              FirebaseUser user =
                                  await _auth.signIn(email, password);
                              setState(() {
                                //isLoading = false;
                              });
                              print(email);
                              print(password);
                              print(user);
                            },
                            padding: EdgeInsets.all(0.0),
                            child: Text('Einloggen'),
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
