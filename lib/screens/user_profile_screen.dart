import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:provider/provider.dart';

import 'package:Sublin/models/user_class.dart';
import 'package:Sublin/screens/provider_registration_screen.dart';
import 'package:Sublin/services/auth_service.dart';
import 'package:Sublin/theme/theme.dart';
import 'package:Sublin/utils/get_readable_user_type.dart';
import 'package:Sublin/widgets/appbar_widget.dart';

enum CardType { email, providerType }

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
      resizeToAvoidBottomPadding: false,
      // bottomNavigationBar: NavigationBarWidget(
      //   isProvider: user.userType != UserType.user,
      // ),
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
                    padding: ThemeConstants.largePadding,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: ThemeConstants.mediumPadding,
                            child: Text(
                              'Status',
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: ThemeConstants.mediumPadding,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Noch nicht abgeschlossen'),
                                SizedBox(
                                  height: 10,
                                ),
                                RaisedButton(
                                    child: AutoSizeText('Jetzt abschließen'),
                                    onPressed: () => Navigator.pushNamed(
                                        context,
                                        ProviderRegistrationScreen.routeName)),
                              ],
                            ),
                          ),
                        )
                      ],
                    )),
              ),
            Column(
              children: [
                UserPersonalDataCard(user: user, cardType: CardType.email),
                UserPersonalDataCard(
                    user: user, cardType: CardType.providerType),
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

class UserPersonalDataCard extends StatelessWidget {
  const UserPersonalDataCard({
    Key key,
    @required this.user,
    @required this.cardType,
  }) : super(key: key);

  final User user;
  final CardType cardType;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
          padding: ThemeConstants.largePadding,
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: ThemeConstants.mediumPadding,
                  child: Text(
                    (_getTitleText(user, cardType)),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: ThemeConstants.mediumPadding,
                  child: Text((_getValueText(user, cardType))),
                ),
              )
            ],
          )),
    );
  }

  String _getTitleText(User user, CardType cardType) {
    switch (cardType) {
      case CardType.email:
        return 'Email';
        break;
      case CardType.providerType:
        return 'Benutzer';
        break;
    }
    return '';
  }

  String _getValueText(User user, CardType cardType) {
    switch (cardType) {
      case CardType.email:
        return user.email;
        break;
      case CardType.providerType:
        return getReadableUserType(user.userType);
        break;
    }
    return '';
  }
}
