import 'package:Sublin/models/sublin_error_enum.dart';
import 'package:Sublin/theme/theme.dart';
import 'package:Sublin/utils/is_email_format.dart';
import 'package:Sublin/widgets/progress_indicator_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';
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
  String _email = '';
  String _password = '';
  SublinError _sublinError;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    if (isLoading == true) {
      return Loading();
    } else {
      return Scaffold(
          resizeToAvoidBottomInset: false,
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
                                validator: (val) => val.length < 2 ||
                                        !isEmailFormat(val)
                                    ? 'Bitte gib eine gültige E-Mailadresse an'
                                    : _sublinError == SublinError.emailNotFound
                                        ? 'Wir konnten diese Emailadresse nicht finden'
                                        : null,
                                onChanged: (val) {
                                  setState(() {
                                    _email = val;
                                    _sublinError = SublinError.none;
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
                                validator: (val) => val.length == 0
                                    ? 'Bitte gib dein Passwort ein'
                                    : _sublinError == SublinError.wrongPassword
                                        ? 'Dein Passwort ist nicht korrekt.'
                                        : null,
                                onChanged: (val) {
                                  setState(() {
                                    _password = val;
                                    _sublinError = SublinError.none;
                                  });
                                },
                                obscureText: true,
                                decoration: InputDecoration(
                                    hintText: 'Passwort',
                                    prefixIcon: Icon(Icons.lock))),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(child: ForgetPassword(email: _email)),
                                Expanded(
                                  child: TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: AutoSizeText(
                                      'Noch nicht registriert?',
                                      maxLines: 1,
                                      style: ThemeConstants.mainButton,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                SizedBox(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      try {
                                        if (_formKey.currentState.validate()) {
                                          SublinError error =
                                              await _auth.signIn(
                                                  email: _email,
                                                  password: _password);
                                          setState(() {
                                            _sublinError = error;
                                          });
                                          _formKey.currentState.validate();
                                        }
                                      } catch (e) {
                                        print(e);
                                      }
                                    },
                                    child: Text('Einloggen'),
                                  ),
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

class ForgetPassword extends StatelessWidget {
  final String email;
  ForgetPassword({this.email});
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        if (isEmailFormat(email)) AuthService().resetPassword(email);
        showModalBottomSheet(
          context: context,
          builder: (context) => GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
                height: 250,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: ThemeConstants.veryLargePadding,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(Icons.close),
                        ],
                      ),
                      if (!isEmailFormat(email))
                        AutoSizeText(
                          'Ups',
                          style: Theme.of(context).textTheme.headline1,
                        ),
                      if (isEmailFormat(email))
                        AutoSizeText(
                          'Eine E-Mail ist unterwegs',
                          style: Theme.of(context).textTheme.headline1,
                        ),
                      SizedBox(
                        height: 20,
                      ),
                      if (!isEmailFormat(email))
                        AutoSizeText(
                          'Bitte gib eine gültige E-Mailaddresse an.',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      if (isEmailFormat(email))
                        AutoSizeText(
                          'Wir haben dir eine E-Mail an $email geschickt, damit du ein neues Passwort vergeben kannst',
                          style: Theme.of(context).textTheme.bodyText1,
                        )
                    ],
                  ),
                )),
          ),
        );
      },
      child: AutoSizeText(
        'Passwort vergessen?',
        maxLines: 1,
        textAlign: TextAlign.start,
        style: ThemeConstants.mainButton,
      ),
    );
  }
}
