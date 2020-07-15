import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sublin/models/auth.dart';
import 'package:sublin/models/provider_user.dart';
import 'package:sublin/models/user.dart';
import 'package:sublin/services/auth_service.dart';
import 'package:sublin/widgets/drawer_side_navigation_widget.dart';
import 'package:sublin/widgets/input/start_end.dart';

class ProviderHomeScreen extends StatefulWidget {
  static const routeName = '/providerHomeScreen';
  @override
  _ProviderHomeScreenState createState() => _ProviderHomeScreenState();
}

class _ProviderHomeScreenState extends State<ProviderHomeScreen> {
  bool textFocus = false;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    final user = Provider.of<User>(context);
    final providerUser = Provider.of<ProviderUser>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text('Sublin'),
          backgroundColor: Colors.black12,
        ),
        drawer: DrawerSideNavigationWidget(
          authService: AuthService(),
        ),
        body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              FocusScope.of(context).unfocus();
              setState(() {
                textFocus = false;
              });
            },
            child: Stack(children: <Widget>[
              SizedBox(
                height: 40,
              ),
              Container(
                padding: EdgeInsets.only(top: 70, left: 15, right: 15),
                width: MediaQuery.of(context).size.width,
                height: 220,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          user.firstName + ',',
                          style: Theme.of(context).textTheme.headline1,
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    AutoSizeText(
                      'bitte suche eine Verbindung zu deiner Betriebsadresse, um herauszufinden, ob sich für deine Postleitzahl bereits ein Anbieter registriert hat.',
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
                  margin: EdgeInsets.only(top: (textFocus) ? 120 : 240),
                  duration: Duration(milliseconds: 100),
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      setState(() {
                        textFocus = true;
                      });
                    },
                    child: StartEnd(
                      startAddress: 'asdfasfdsdf',
                      showStartAddress: false,
                      buttonText: 'Anbieter suchen',
                      providerRequest: true,
                    ),
                  ))
            ])));
  }
}
