import 'package:Sublin/models/user_class.dart';
import 'package:Sublin/models/user_type_enum.dart';
import 'package:Sublin/services/auth_service.dart';
import 'package:Sublin/theme/theme.dart';
import 'package:Sublin/widgets/appbar_widget.dart';
import 'package:Sublin/widgets/navigation_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProviderPartnerScreen extends StatefulWidget {
  static const routeName = './providerPartnerScreenState';
  @override
  _ProviderPartnerScreenState createState() => _ProviderPartnerScreenState();
}

class _ProviderPartnerScreenState extends State<ProviderPartnerScreen> {
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context);
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      bottomNavigationBar:
          NavigationBarWidget(isProvider: user.userType != UserType.user),
      appBar: AppbarWidget(title: 'Partner'),
      body: SafeArea(
        child: SizedBox(
          width: screenWidth,
          child: Padding(
            padding: ThemeConstants.largePadding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: screenWidth / 1.5,
                  child: Column(
                    children: [
                      Text(
                        'Keine Partner vorhanden',
                        style: Theme.of(context).textTheme.headline1,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Derzeit können alle deinen Shuttledienst vom Bahnhof zu deiner Addresse in Anspruch nehmen.',
                        style: Theme.of(context).textTheme.bodyText1,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      RaisedButton(
                          onPressed: null,
                          child: Text('Zielgruppe einschränken')),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
