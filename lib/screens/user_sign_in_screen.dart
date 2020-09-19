import 'package:Sublin/theme/theme.dart';
import 'package:Sublin/utils/is_email_format.dart';
import 'package:Sublin/widgets/progress_indicator_widget.dart';
import 'package:flutter/material.dart';
import 'package:Sublin/widgets/loading_widget.dart';
import 'package:Sublin/services/auth_service.dart';

class UserSignInScreen extends StatefulWidget {
  static const routeName = '/signInScreen';
  @override
  _UserSignInScreenState createState() => _UserSignInScreenState();
}

class _UserSignInScreenState extends State<UserSignInScreen> {
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
          body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            ProgressIndicatorWidget(
              index: 1,
              elements: 1,
              showProgressIndicator: false,
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              padding: EdgeInsets.all(15),
              width: MediaQuery.of(context).size.width,
              height: 60,
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
                        TextFormField(
                            validator: (val) =>
                                val.length < 2 || !isEmailFormat(val)
                                    ? 'Bitte gib eine gültige E-Mailadresse an'
                                    : null,
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
                            decoration: InputDecoration(
                                hintText: 'Passwort',
                                prefixIcon: Icon(Icons.lock))),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            FlatButton(
                              textColor: Theme.of(context).secondaryHeaderColor,
                              onPressed: () => Navigator.pop(context),
                              child: Text(
                                'Noch nicht registriert?',
                                style: ThemeConstants.mainButton,
                              ),
                            ),
                            RaisedButton(
                              onPressed: () async {
                                try {
                                  if (_formKey.currentState.validate()) {
                                    await _auth.signIn(
                                        email: email, password: password);
                                  }
                                } catch (e) {
                                  print(e);
                                }
                              },
                              child: Text('Einloggen'),
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
        ),
      ));
    }
  }
}
