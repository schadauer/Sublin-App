import 'package:flutter/material.dart';
import 'package:Sublin/screens/provider/provider_registration_screen.dart';
import 'package:Sublin/screens/user/user_home_screen.dart';
import 'package:Sublin/services/auth_service.dart';

class DrawerSideNavigationWidget extends StatelessWidget {
  const DrawerSideNavigationWidget({
    Key key,
    @required this.authService,
  }) : super(key: key);

  final AuthService authService;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          // DrawerHeader(child: Text('Navigation')),
          SizedBox(
            height: 30,
          ),
          ListTile(
            leading: Icon(Icons.person_outline),
            title: Text('Persönliche Einstellungen'),
            onTap: null,
          ),
          ListTile(
            leading: Icon(Icons.person_outline),
            title: Text('Fahrt suchen'),
            onTap: () => Navigator.pushNamed(context, UserHomeScreen.routeName),
          ),
          ListTile(
            leading: Icon(Icons.person_outline),
            title: Text('Als Anbieter starten'),
            onTap: () => Navigator.pushNamed(
                context, ProviderRegistrationScreen.routeName),
          ),
          ListTile(
            leading: Icon(Icons.power_settings_new),
            title: Text('Ausloggen'),
            onTap: () => authService.signOut(),
          ),
        ],
      ),
    );
  }
}
