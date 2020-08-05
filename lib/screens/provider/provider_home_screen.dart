import 'package:Sublin/models/provider_type.dart';
import 'package:Sublin/models/provider_user.dart';
import 'package:Sublin/models/user.dart';
import 'package:Sublin/services/auth_service.dart';
import 'package:Sublin/utils/get_part_of_address.dart';
import 'package:Sublin/widgets/drawer_side_navigation_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProviderHomeScreen extends StatefulWidget {
  @override
  _ProviderHomeScreenState createState() => _ProviderHomeScreenState();
}

class _ProviderHomeScreenState extends State<ProviderHomeScreen> {
  @override
  Widget build(BuildContext context) {
    final providerUser = Provider.of<ProviderUser>(context);
    final User user = Provider.of<User>(context);

    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: AppBar(
            title: Text('Home'),
            elevation: 0.0,
            backgroundColor: Theme.of(context).primaryColor,
            leading: Image.asset(
              'assets/images/Sublin.png',
              scale: 1.3,
            ),
          ),
        ),
        endDrawer: DrawerSideNavigationWidget(
          authService: AuthService(),
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // If the user is not yet approved as provider
              if (providerUser.operationRequested && !providerUser.inOperation)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '${user.firstName}, du bist ein Star!',
                          style: Theme.of(context).textTheme.headline3,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        if (providerUser.providerType == ProviderType.taxi)
                          AutoSizeText(
                            'Du bist jetzt als das Taxi- oder Mietwagenunternehmen für ${getPartOfAddress(providerUser.addresses[0], '__')} vorgemerkt.',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                      ],
                    ),
                  ),
                )
            ],
          ),
        ));
  }
}
