import 'package:Sublin/models/user_class.dart';
import 'package:Sublin/models/user_type_enum.dart';
import 'package:Sublin/screens/provider_registration_screen.dart';
import 'package:Sublin/services/auth_service.dart';
import 'package:Sublin/theme/theme.dart';
import 'package:Sublin/widgets/appbar_widget.dart';
import 'package:Sublin/widgets/navigation_bar_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProfileScreen extends StatefulWidget {
  static const routeName = './userProfileScreenState';
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context);

    return Scaffold(
      bottomNavigationBar:
          NavigationBarWidget(isProvider: user.userType != UserType.user),
      appBar: AppbarWidget(title: 'Mein Profil', showProfileIcon: false),
      body: SafeArea(
        child: Column(
          children: [
            Container(
                height: 200,
                color: Theme.of(context).primaryColor,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.face,
                          color: Theme.of(context).primaryColor,
                          size: 80,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        user.firstName,
                        style: Theme.of(context).textTheme.headline1,
                      )
                    ],
                  ),
                )),
            if (user.isRegistrationCompleted != true)
              Card(
                  child: Padding(
                padding: ThemeConstants.mediumPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      'Registrierung noch nicht abgeschlossen',
                      style: Theme.of(context).textTheme.headline1,
                      maxLines: 2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        RaisedButton(
                            child: AutoSizeText('Jetzt abschließen'),
                            onPressed: () => Navigator.pushNamed(
                                context, ProviderRegistrationScreen.routeName)),
                      ],
                    )
                  ],
                ),
              )),
            Row(
              children: [
                FlatButton(
                  onPressed: () => AuthService().signOut(),
                  child: Text('Ausloggen'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
